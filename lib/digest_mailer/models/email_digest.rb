require_relative 'email_message'
class EmailDigest < ActiveRecord::Base
  belongs_to :user
  belongs_to :digest_type
  has_and_belongs_to_many :email_messages
  validates_presence_of :user
  
  #scope :frequency, lambda { |*args| {:conditions => ["frequency = ?", (args.first || 'weekly')]} }
  #scope :unsent, lambda {|*args| {:conditions => "intended_sent_at=null", :limit => 1}}
  
  before_create :grab_preferences_for_user
  
  def grab_preferences_for_user
    self.digest_type = DigestType.find_or_create_by_name(self.user.receive_frequency) if (!self.digest_type)
    self.embargoed_until = EmailDigest.embargoed_until_by_digest_type(self.digest_type)
  end
  
  def self.embargoed_until_by_digest_type(digest_type)
    case digest_type.name
    when 'daily'
      Time.now.midnight
    when 'weekly'
      Time.next(:monday).beginning
    end
  end
  
  def digest_body
    DigestMailer::Layouts::TextDigest.layout(self.email_messages)
  end
  
  def append_message(email_message)
    self.email_messages << email_message
  end
  
  def sent?
    self.intended_sent_at.exists?
  end
  
  def send_message
    msg = build_digest_message()
    self.intended_sent_at = Time.now
    self.save
    msg.send_message
  end
  
  def build_digest_message() 
    msg_body = construct_message_body()
    email_message = EmailMessage.new(:from_email => "mailer@victorsandspoils.com", 
                                      :body => msg_body, 
                                      :subject => "#{digest_type.name.capitalize} Digest from Victors & Spoils", :body_type => 'plain', :email_type => 'digest', :collation_type => "#{digest_type}")
    DigestMailer::PendingMessage.new(self.user, email_message, Time.now, 'generic_message')
  end
  
  def construct_message_body()
    body = ""
#    @sent_at_hash = Hash.new if !@sent_at_hash
    self.email_messages.each do |msg|
 #     @sent_at_hash[msg] = Time.now if !@sent_at_hash[msg]
      body += "\r------------\r"
      body += msg.to_digest_fragment
    end
    body
  end
  
end

class Time
  class << self
    def next(day, from = nil)
      day = [:sunday,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday].find_index(day) if day.class == Symbol
      one_day = 60 * 60 * 24
      original_date = from || now
      result = original_date
      result += one_day until result > original_date && result.wday == day 
      result
    end
  end
  
  def beginning
    Time.new(self.year, self.month, self.day)
  end
end
