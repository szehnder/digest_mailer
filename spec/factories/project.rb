Factory.define :project, :default_strategy => :build do |project|
  project.title "This is a title"
  project.content "This is the content"
  project.award "This is the award"
  project.target "This is the target"
  project.objective "This is the objective"
  project.about "This is the about"
  project.video_embed_code "This is the video embed code"
  project.teaser "This is the teaser"
  project.start_at { Time.now - 2.days }
  project.end_at { Time.now + 20.days }
  project.required_creative_count 300
#  project.private true
end

Factory.define :public_project, :default_strategy => :build, :class => 'Project' do |project|
  project.title "This is a title"
  project.content "This is the content"
  project.award "This is the award"
  project.target "This is the target"
  project.objective "This is the objective"
  project.about "This is the about"
  project.video_embed_code "This is the video embed code"
  project.teaser "This is the teaser"
  project.start_at { Time.now - 2.days }
  project.end_at { Time.now + 20.days }
  project.required_creative_count 300
 # project.private false
end