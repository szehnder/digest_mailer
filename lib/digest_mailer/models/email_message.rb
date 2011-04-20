require_relative 'email_digest'
class EmailMessage < ActiveRecord::Base
    has_many :email_logs
    has_and_belongs_to_many :email_digests
    
    def to_digest_fragment()
      "Sent at: #{self.intended_sent_at}\r"+
      "Subject: #{self.subject}\r"+
      "From: #{self.from_email}\r"+
      "\r#{self.body}\r"
    end
end