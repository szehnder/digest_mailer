#require File.expand_path("../lib/digest_mailer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'digest_mailer'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sean Zehnder"]
  s.email       = ["szehnder@victorsandspoils.com"]
  s.homepage    = "http://github.com/szehnder/digest_mailer"
  s.summary     = "A mailer that uses delayed_job and can handle batching into digests"
  s.description = "This library provides a batch mailer that can either dispatch immediately, or as a an email digest.  It uses the delayed_job gem in order to do the email dispatching as a background process."

  s.required_rubygems_version = ">= 1.7.2"

  # lol - required for validation
  s.rubyforge_project         = "digest_mailer"

  # If you need to check in files that aren't .rb files, add them here
  s.files             = Dir.glob('{lib, spec}') +
                          %w(MIT-LICENSE README.textile)
  s.require_path      = ['lib']
  s.extra_rdoc_files  = 'README.textile'
  s.rdoc_options      = ["--main", "README.textile", "--inline-source", "--line-numbers"]
  s.test_files        = Dir.glob('spec/**/*')

  # If you need an executable, add it here
  # s.executables = ["newgem"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"

  # If you have other dependencies, add them here
  s.add_dependency              'delayed_job',    '~> 2.1.4'
  s.add_runtime_dependency      'activesupport',  '~> 3.0'
  
  s.add_development_dependency  'rails',          '~> 3.0'
  s.add_development_dependency  'rspec',          '~> 2.0'
  s.add_development_dependency  'rake'
  s.add_development_dependency  'sqlite3'
end