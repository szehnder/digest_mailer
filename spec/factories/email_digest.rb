Factory.define :daily_digest, :default_strategy => :build, :class => EmailDigest do |msg|
  msg.association(:user, :factory => :daily_digest_user)
  msg.association(:digest_type, :factory => :daily)
  msg.after_create{ |m| m.grab_preferences_for_user }
end

Factory.define :weekly_digest, :default_strategy => :build, :class => EmailDigest do |msg|
  msg.association :user, :factory => :weekly_digest_user
  msg.intended_sent_at Time.now
  msg.association(:digest_type, :factory => :weekly)
  msg.after_create{ |m| m.grab_preferences_for_user }
end

Factory.define :email_digest, :default_strategy => :build do |msg|
    msg.intended_sent_at Time.now
    msg.after_create{ |m| m.grab_preferences_for_user }
end