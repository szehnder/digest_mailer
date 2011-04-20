require_relative 'models/non_user_recipient'
module DigestMailer
  class MailOrchestrator
    
    def self.prepare(message_params, other_recipients = [], from_email = "Victors & Spoils <noreply@victorsandspoils.com>")
      #message_params[:other_recipients] = other_recipients
      skip_user_preferences = should_skip_user_preferences_by_scope(message_params[:scope])
      recipients = recipients_by_scope(message_params)
      email_message = EmailMessage.create(:from_email => from_email, :body => message_params[:body], :subject => message_params[:subject], :body_type => 'plain', :intended_sent_at => Time.now)
      
      #send the email to all the write-in recipients
      other_recipients.each do |recip|
        if(recip!="")
          msg = PendingMessage.new(NonUserRecipient.new(recip), email_message, Time.now, 'generic_message')
          MailDelayedJobScheduler.enqueue_message(msg)
        end
      end

      if (skip_user_preferences) #this would indicate the message should be sent immediately
        #enqueue this message for immediate delivery to all recipients
        if (recipients.count>0) 
          recipients.each do |r|
            msg = PendingMessage.new(r, email_message, Time.now, 'generic_message')
            MailDelayedJobScheduler.enqueue_message(msg)
          end
        end
      else
        recipients = separate_immediate_from_digest_recipients(recipients)
        #enqueue this message for immediate delivery to all immediate_recipients
        #email_message = EmailMessage.create(:from_email => from_email, :body => message_params[:body], :subject => message_params[:subject], :body_type => 'plain', :intended_sent_at => Time.now)
        if (recipients[:immediate].count>0)
          recipients[:immediate].each do |r|
            msg = PendingMessage.new(r, email_message, Time.now, 'generic_message')
            MailDelayedJobScheduler.enqueue_message(msg)
          end
        end
        #next, create and enqueue a digest message for each user who has requested a digest format

        recipients[:digest].each do |u|
          if(MailDelayedJobScheduler.user_has_pending_digest?(u))
            digest = MailDelayedJobScheduler.get_pending_digest_for_user(u)
            digest.append_message(email_message)
            #MailDelayedJobScheduler.enqueue_digest(digest)
          else
            digest = EmailDigest.create(:user => u)
            digest.append_message(email_message)
            MailDelayedJobScheduler.enqueue_digest(digest)
          end
        end
      end
    end

    def self.separate_immediate_from_digest_recipients(recipients)
      digest = []
      immediate = []
      recipients.each do |user|
        if (user_prefers_email_digests(user))
          digest << user
        else
          immediate << user
        end
      end
      {:digest => digest, :immediate => immediate}
    end

    #Prepares an array of users to receive this email based on the email's designated scope
    def self.recipients_by_scope(message_params)
      recipients = []
      case message_params[:scope]
      when "by_user_id"
        recipients = [User.find(message_params[:id])]
      when "by_project_id"
        recipients = Project.find(message_params[:id]).users
      when "by_all_users_with_idea_on_a_project"
        recipients = User.find(Project.find(message_params[:id]).ideas.find(:all, :select => "DISTINCT user_id").collect{|p| p.user_id})
      when "by_user_array"
        recipients = message_params[:user_recipients]
      when "by_all_users"
        recipients = User.all
      when "by_discipline_id"
        recipients = User.find(:all, :conditions => "discipline_id = #{message_params[:id]}")
      when 'by_invite_user_id'
        recipients << message_params[:id]
      when 'by_all_users_with_idea'
        recipients = User.find(Idea.find(:all, :select => "DISTINCT user_id").collect{|i| i.user_id })
      end
      recipients.uniq
    end

    #Determines whether or not this type of email should honor the user's preferred format (meaning 'immediate' or 'digest')
    def self.should_skip_user_preferences_by_scope(scope)
      case scope
      when "by_user_id"
        false
      when "by_user_array"
        false
      when "by_all_users"
        false
      when "by_project_id"
        true
      when "by_all_users_with_idea_on_a_project"
        true
      when "by_discipline_id"
        true
      when "by_invite_user_id"
        true
      when "by_all_users_with_idea"
        true
      end
    end

    # Determines if the recipient can receive email    
    def self.user_can_receive_emails(user)
      user.confirmed_at ? ((user.receive_notifications == 1) || (user.receive_notifications) ? true : false) : false
    end

    #Determines if the user has specifically requested email digests
    #The default is 'immediate' emails, which means they get sent as soon as possible
    def self.user_prefers_email_digests(user)
      if (user_can_receive_emails(user))
        #(!user.receive_frequency || !user.receive_frequency.blank?) ? (user.receive_frequency.downcase=='immediately') : false
        !(user.receive_frequency.downcase=='immediately')
      else
        false
      end
    end

  end
end