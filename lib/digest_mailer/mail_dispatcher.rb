module DigestMailer
  class MailDispatcher < ActionMailer::Base
    default :from => "Victors & Spoils <noreply@victorsandspoils.com>"

    # entity registration receipt
    def self.entity_registration_receipt(entity)
      @entity = entity
      mail(:to => "help@victorsandspoils.com", :subject => "New Client Registration")
    end
    
    # entity message
    def self.entity_message(entity)
      @entity = entity
      mail(:to => entity.users.first.email, :subject => "Thanks for Contacting Victors & Spoils")
    end
    
    # Contact form confirmation message
    def self.contact_message(contact)
      @contact = contact
      mail(:to => contact.email, :subject => "Thanks for Contacting Victors & Spoils")
    end

    # Contact form to help@victorsandspoils.com
    def self.contact_message_receipt(contact)
      @contact = contact
      mail(:to => "help@victorsandspoils.com", :subject => "V&S Contact Form")
    end

    # Email receipt that idea was properly submitted
    def self.idea_message(idea)
      @idea = idea
      mail(:to => idea.user.email, :subject => idea.title)
    end

    # Email message notifying V&S of an idea submission
    def self.idea_notice(idea)
      @idea = idea
      mail(:to => "help@victorsandspoils.com", :subject => "Victors & Spoils Idea Notice")
    end

    # Used for admin messages and anything generic
    def generic_message(recipient_email, msg)
      @body = msg[:body]
        mail(:to => recipient_email, :from => msg[:from_email], :subject => msg[:subject])
        MailLogger.log(recipient_email, msg, 'generic_message', msg[:intended_sent_at])
       # Rails.logger.info("[Mailer Example]\r\rTo: #{recipient_email}\rFrom: #{msg[:from_email]}\rSubject: #{msg[:subject]}\r#{msg[:body]}")
    end
    
    # used for digest emails
    def self.digest_message(msg)
      @msg = msg
      mail(:to => msg[:to], :subject => msg[:subject])
    end

    # Sends email when users who have been imported into the new site from the old
    def self.invite_legacy_user_message(user)
      @user = user
      DigestMailer::MailDispatcher.mail(:to => user.email, :subject => "Update your V&S Account")
    end
    
  end
end
