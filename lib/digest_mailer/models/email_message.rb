class EmailMessage < ActiveRecord::Base
    has_many :email_logs
    has_and_belongs_to_many :email_digests
    
    def to_digest_fragment
      "Subject: #{self.subject}\r"+
      "From: #{self.from_email}\r"+
      "Sent at: #{self.intended_sent_at}\r\r"+
      "#{self.body}"
    end
end
