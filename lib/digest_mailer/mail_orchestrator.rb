module DigestMailer
  class MailOrchestrator
    
    def prepare(message_params, user_recipients, from_email = "Victors & Spoils <noreply@victorsandspoils.com>")
      message_params[:user_recipients] = users
      scope = (message_params[:scope].to_s.include? "|") ? message_params[:scope].to_s.split("|")[0] : message_params[:scope] 
      skip_user_preferences = should_skip_user_preferences_by_scope(scope)
      recipients = recipients_by_scope(scope, message_params)
      
      if (skip_user_preferences) do #this would indicate the message should be sent immediately
        #enqueue this message for immediate delivery to all recipients
        if (recipients.count>0) do
          email_message = EmailMessage.new(:recipients => recipients, :from_email => from_email, :message_params => message_params)
          MailDelayedJobScheduler.enqueue_message(email_message)
        end
      else
        recipients = separate_immediate_from_digest_recipients(recipients)
        #enqueue this message for immediate delivery to all immediate_recipients
        if (recipients[:immediate].count>0) do
          email_message = EmailMessage.new(:recipients => recipients, :from_email => from_email, :message_params => message_params)
          MailDelayedJobScheduler.enqueue_message(email_message)
        end
        #next, create and enqueue a digest message for each user who has requested a digest format
        recipients[:digest].each do |u|
          email_message = EmailMessage.new(:from_email => from_email, :message_params => message_params)
          if(MailDelayedJobScheduler.user_has_pending_digest?(u)) do
            digest = MailDelayedJobScheduler.get_pending_digest_for_user(u)
            digest.append_message(email_message)
            MailDelayedJobScheduler.enqueue_digest(digest)
          else
            digest = EmailDigest.create(u)
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
     def self.recipients_by_scope(scope, message_params)
        recipients = []
        case scope
          when "by_user_id"
            recipients << message_params[:id]
          when "by_project_id"
            Project.find(id).ideas.find(:all, :select => "DISTINCT user_id").each do |idea|
              recipients << idea.user_id
            end
          when "by_user_array"
            recipients = message_params[:user_recipients]
          when "by_all_users"
            recipients = Users.all
          when "by_discipline_id"
            discipline_id = (message_params[:scope].to_s.include? "|") ? message_params[:scope].to_s.split("|")[1] : nil
            User.find(:all, :conditions => "discipline_id = #{discipline_id}").each do |user|
              recipients << user.id
            end
          when 'by_invite_user_id'
            recipients << message_params[:id]
          when 'by_all_users_with_idea'
            Idea.find(:all, :select => "DISTINCT user_id").each do |idea|
              recipients << idea.user_id
            end
        end
        recipients
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
          when "by_discipline_id"
            true
          when "by_invite_user_id"
            true
          when "by_all_users_with_idea"
            true
          end
        end
      end
    
    # Determines if the recipient can receive email    
    def self.user_can_receive_emails(user)
        user.confirmed_at ? ((user.receive_notifications == 1) || (user.receive_notifications) ? true : false) : false
    end
    
    #Determines if the user has specifically requested email digests
    #The default is 'immediate' emails, which means they get sent as soon as possible
    def self.user_prefers_email_digests(user)
       if (user_can_receive_emails(user)) do
          (!user.receive_frequency || !user.receive_frequency.blank?) ? (user.receive_frequency.downcase=='immediately') : false
       else
         false
       end
    end
    
  end
end