class EmailDigest < ActiveRecord::Base
  belongs_to :user
  #has_and_belongs_to_many :email_messages
  #scope :frequency, lambda { |*args| {:conditions => ["frequency = ?", (args.first || 'weekly')]} }
  #scope :unsent, lambda {|*args| {:conditions => "intended_sent_at=null", :limit => 1}}
  
  def digest_body
    DigestMailer::Layouts::TextDigest.layout(self.email_messages)
  end
  
  def append_message(email_message)
    self.email_messages << email_message
  end
  
  def sent?
    self.intended_sent_at.exists?
  end
  
end
