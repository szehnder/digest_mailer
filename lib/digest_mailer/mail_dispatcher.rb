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
    def self.generic_message(recipient, msg)
      @msg = msg
      mail(:to => recipient, :from => msg[:from_email], :subject => msg[:subject])
    end

    # used for digest emails
    def self.digest_message(msg)
      @msg = msg
      mail(:to => msg[:to], :subject => msg[:subject])
    end

    # Sends email when users who have been imported into the new site from the old
    def self.invite_legacy_user_message(user)
      @user = user
      mail(:to => user.email, :subject => "Update your V&S Account")
    end
    
  end
end
