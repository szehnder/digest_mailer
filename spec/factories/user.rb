Factory.define :user, :default_strategy => :build do |user|
  user.sequence(:email) {|n| "info#{n}@victorsandspoils.com"}
  user.first_name "General"
  user.last_name "User"
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
end

Factory.define :szehnder1, :default_strategy => :build, :class => 'User' do |user|
  user.email 'seanzehnder@gmail.com'
  user.first_name "Sean1"
  user.last_name "Zehnder"
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
  user.receive_frequency 'daily'
end

Factory.define :szehnder2, :default_strategy => :build, :class => 'User' do |user|
  user.email 'sean@socialesque.com'
  user.first_name "Sean2"
  user.last_name "Zehnder"
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
  user.receive_frequency 'daily'
end

Factory.define :daily_digest_user, :default_strategy => :build, :class => 'User' do |user|
  user.sequence(:email) {|n| "info#{n}@victorsandspoils.com"}
  user.first_name "General"
  user.last_name "User"
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
  user.receive_frequency 'daily'
end

Factory.define :weekly_digest_user, :default_strategy => :build, :class => 'User' do |user|
  user.sequence(:email) {|n| "info#{n}@victorsandspoils.com"}
  user.first_name "General"
  user.last_name "User"
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
  user.receive_frequency 'weekly'
end

Factory.define :admin, :default_strategy => :build, :class => 'User' do |user|
  user.first_name "Quick"
  user.last_name "Left"
  user.email "admin@victorsandspoils.com"
#  user.roles { [  ] }
  user.discipline_id 1
  user.confirmed_at Time.new.to_s
  user.confirmation_sent_at Time.new.to_s
  user.city "Boulder"
  user.state "CO"
  user.country "USA"
  user.zip_code "80302"
  user.years_of_experience "2 - 4 years"
  user.birth_day "1978-08-14 00:00:00"
end

Factory.define :creative_director_user, :default_strategy => :build, :class => 'User' do |creative_director|
  creative_director.first_name "Creative"
  creative_director.last_name "Director"
  creative_director.email "creative@victorsandspoils.com"
#  creative_director.roles { [ @member_role ] }
  creative_director.discipline_id 1
  creative_director.confirmed_at Time.new.to_s
  creative_director.confirmation_sent_at Time.new.to_s
  creative_director.city "Boulder"
  creative_director.state "CO"
  creative_director.country "USA"
  creative_director.zip_code "80302"
  creative_director.years_of_experience "2 - 4 year"
  creative_director.birth_day "1978-08-14 00:00:00"
end

Factory.define :invalid_user, :default_strategy => :build, :class => 'User' do |user|
end
