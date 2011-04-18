Factory.define :digest_type, :default_strategy => :build do |d| 
  d.name 'monthly'
end

Factory.define :daily, :default_strategy => :build, :class => 'DigestType' do |d| 
  d.name 'daily'
end

Factory.define :weekly, :default_strategy => :build, :class => 'DigestType' do |d| 
  d.name 'weekly'
end