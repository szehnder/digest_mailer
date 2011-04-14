Factory.define :daily, :default_strategy => :build, :class => EmailDigest do |msg|
  msg.user_id 1 #Fixme - not sure what this field represents
  msg.association :to, :factory => :daily_digest_user
  msg.freq 'daily'
  msg.body_plain 'This is the body of a test email for DAILY digests'
  msg.body_html '<p>This is the body of a test HTML email for DAILY digests'
  msg.association :from, :factory => :admin
  msg.subject 'this is the subject line'
  msg.intended_sent_at Time.now
end

Factory.define :weekly, :default_strategy => :build, :class => EmailDigest do |msg|
  msg.user_id 1 #Fixme - not sure what this field represents
  msg.association :to, :factory => :weekly_digest_user
  msg.freq 'daily'
  msg.body_plain 'This is the body of a test email for DAILY digests'
  msg.body_html '<p>This is the body of a test HTML email for DAILY digests'
  msg.association :from, :factory => :admin
  msg.subject 'this is the subject line'
  msg.intended_sent_at Time.now
end