class EmailLog < ActiveRecord::Base
  belongs_to :email_message
  validates_presence_of :recipient_id
  validates_presence_of :mailer_method
  validates_presence_of :email_message
  validates_presence_of :intended_sent_at
end