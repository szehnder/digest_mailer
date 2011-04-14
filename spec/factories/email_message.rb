Factory.define :plain_email, :default_strategy => :build, :class => 'EmailMessage' do |msg|
  msg.from_email "admin@victorsandspoils.com"
  msg.subject "This is a subject line"
  msg.body "This is the body of a plain text email"
  msg.body_type "plain"
  msg.email_type "generic_message"
end

Factory.define :html_email, :default_strategy => :build, :class => 'EmailMessage' do |msg|
  msg.from_email "admin@victorsandspoils.com"
  msg.subject "This is a subject line"
  msg.body "<h2>html email</h2><p>This is the body of an html email</p>"
  msg.body_type "html"
  msg.email_type "generic_message"
end