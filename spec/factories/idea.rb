Factory.define :idea, :default_strategy => :build do |idea|
  idea.title "This title is the default."
  idea.explanation "This explanation is the default."
  idea.state 'new'
end

Factory.define :idea2, :default_strategy => :build, :class => 'Idea' do |idea|
  idea.title "This title is the default."
  idea.explanation "This explanation is the default."
  idea.state 'new'
end