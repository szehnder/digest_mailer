Factory.define :standard_role, :default_strategy => :build, :class => 'Role' do |role|
  role.name "Member"
end

Factory.define :admin_role, :default_strategy => :build, :class => 'Role' do |role|
  role.name "Admin"
end

Factory.define :cd_role, :default_strategy => :build, :class => 'Role' do |role|
  role.name "Creative Director"
end