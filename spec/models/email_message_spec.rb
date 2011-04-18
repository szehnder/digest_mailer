Factory.define :plain__message, :default_strategy => :build do |msg|
  msg.body 'this is a plain text email.  it is pretty boring.'
  msg.from_email 'admin@victorsandspoils.com'
  msg.body_type 'plain'
  msg.subject 'this is a subject line'
  msg.collation_type 'daily'
  msg.email_type 'digest'
end

Factory.define :html_message, :default_strategy => :build, :class => 'EmailMessage' do |msg|
  msg.body '<h2>Victors &amp; Spoils</h2><p>this is an <b>HTML</b> email.  it is pretty boring.</p>'
  msg.from_email 'admin@victorsandspoils.com'
  msg.body_type 'html'
  msg.subject 'this is a subject line of an html email'
  msg.collation_type 'none'
  msg.email_type 'default'
end