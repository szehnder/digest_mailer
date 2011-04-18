module DigestMailer
  class MailLogger
    
    def self.log(msg)
      EmailLog.create(:recipient_id => msg[:recipient][:id], :email_message_id => msg[:message][:id], 
                        :mailer_method => msg[:mailer_method], :intended_sent_at => msg[:intended_sent_at])
    end
  end
end