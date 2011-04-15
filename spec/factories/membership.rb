Factory.define :membership, :default_strategy => :build, :class => 'Membership' do |m|
  m.association(:role, :factory => :standard_role)
end

Factory.define :cd_membership, :default_strategy => :build, :class => 'Membership' do |m|
  m.association(:role, :factory => :cd_role)
end