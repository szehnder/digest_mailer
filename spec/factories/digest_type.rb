Factory.define :daily, :default_strategy => :build, :class => 'DigestType' do |d| 
  d.name 'Daily'
end

Factory.define :weekly, :default_strategy => :build, :class => 'DigestType' do |d| 
  d.name 'Weekly'
end