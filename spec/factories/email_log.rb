Factory.define :email_log, :default_strategy => :build do |msg|
  msg.recipient_email 'foo@mail.com'
  msg.association(:email_message, :factory => :plain_email )
  msg.mailer_method 'generic_message'
  msg.intended_sent_at Time.now
end
  