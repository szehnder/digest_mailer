module DigestMailer
  class MailLogger
    
    def self.log(msg)
      EmailLog.create(:user_id => msg[:from].id, :to => msg[:to].id, :body_plain => msg[:body_plain], :body_html => msg[:body_html], :from => msg[:from].id, :subject => msg[:subject], :intended_sent_at => msg[:intended_sent_at])
    end
  end
end