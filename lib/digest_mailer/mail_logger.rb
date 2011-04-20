module DigestMailer
  class MailLogger
    
    def self.log(recipient, email_message, mailer_method, intended_sent_at)
      EmailLog.create(:recipient_email => recipient, :email_message_id => email_message.id, 
                        :mailer_method => mailer_method, :intended_sent_at => intended_sent_at)
    end
  end
end