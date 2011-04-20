$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'logger'

require 'rails'
require 'active_record'
require 'action_mailer'

require 'factory_girl'
require 'delayed_job'
require 'database_cleaner'
require 'shoulda' 

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
 
#DigestMailer::MailOrchestrator.logger = Logger.new('/tmp/digest_mailer.log')
ENV['RAILS_ENV'] = 'test'

config = YAML.load(File.read('spec/database.yml'))
ActiveRecord::Base.configurations = {'test' => config['mysql2']}
ActiveRecord::Base.establish_connection

ActiveRecord::Migration.verbose = false
Rails.logger = Logger.new(File.open('log/digest_mailer_test.log', 'w'))
ActiveRecord::Base.logger = Logger.new(File.open('log/digest_mailer_activerecord.log', 'w'))

ActiveRecord::Schema.define do
  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0
    table.integer  :attempts, :default => 0
    table.text     :handler
    table.text     :last_error
    table.datetime :run_at
    table.datetime :locked_at
    table.datetime :failed_at
    table.string   :locked_by
    table.timestamps
  end

  add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

  create_table :email_logs, :force => true do |t|
    t.integer :recipient_id
    t.string :recipient_email
    t.references :email_message
    t.datetime :intended_sent_at
    t.string :mailer_method
    t.timestamps
  end

  create_table :email_digests, :force => true do |t|
    t.references :user
    t.references :digest_type
    t.datetime :intended_sent_at
    t.datetime :embargoed_until
    t.timestamps
  end
  
  create_table :digest_types, :force => true do |t|
    t.string :name
  end

  create_table :email_messages, :force => true do |t|
    t.text :body
    t.string :from_email
    t.string :body_type #html or plain
    t.string :subject
    t.string :collation_type #individual, daily_digest, weekly_digest
    t.string :email_type #this will be the name of the email method, such as 'generic_message'
    t.datetime :intended_sent_at #optional - only really used when the email is being packaged in a digest
  end

  create_table :email_digests_email_messages, :force => true, :id => false do |t|
    t.references :email_digest
    t.references :email_message
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",            :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "",            :null => false
    t.string   "password_salt",                        :default => "",            :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.datetime "deleted_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "gender"
    t.datetime "birth_day"
    t.string   "years_of_experience"
    t.text     "message"
    t.string   "receive_frequency",                    :default => "immediately"
    t.string   "nickname"
    t.boolean  "starred",                              :default => false
    t.integer  "discipline_id"
    t.integer  "is_employed",                          :default => 0,             :null => false
    t.string   "registration_source"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "title"
    t.string   "current_employer"
    t.boolean  "receive_notifications",                :default => true
    t.string   "admin_note"
    t.integer  "entity_id"
    t.string   "twitter"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.timestamps "created_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table :projects, :force => true do |t|
    t.text     :content
    t.string   :title
    t.datetime :start_at
    t.datetime :end_at
    t.text     :award
    t.string   :target
    t.text     :objective
    t.text     :about
    t.text     :video_embed_code
    t.text     :teaser
    t.string   :image_file_name
    t.string   :image_content_type
    t.string   :image_file_size
    t.datetime :image_updated_at
    t.string   :cached_slug
    t.datetime :created_at
    t.datetime :updated_at
    t.string   :dollars
    t.string   :on_homepage
    t.boolean  :private
    t.integer  :required_creative_count
    t.string   :current_state
  end

  create_table :ideas, :force => true do |t|
    t.references :user, :project, :parent
    t.timestamps
    t.string   :title
    t.text     :explanation
    t.string   :state
  end
  
  create_table :memberships, :id => false, :force => true do |t|
    t.references :role
    t.references :user
    t.references :memberable, :polymorphic => true
  end
end


class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :email_digests
  has_many :ideas
  attr_accessible :first_name, :last_name, :email, :email_confirmation, :password, :password_confirmation, :remember_me, :city, :state, :zip_code,
  :country, :gender, :birth_day, :years_of_experience, :message, :receive_frequency, :nickname, :discipline_id,
  :is_employed, :registration_source, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at,
  :title, :current_employer, :receive_notifications, :employer_ids, :work_links_attributes, :employers_attributes, :employers_attributes, :avatar, :portfolios, :admin_note, :entity_id, :registration_source, :twitter, :contract_ids, :role_ids

  has_many :memberships
  has_many :projects, :through => :memberships, :source => :memberable, :source_type => 'Project'

end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
end

class Project < ActiveRecord::Base
  has_many :ideas
  has_many :memberships, :as => :memberable
  has_many :users, :through => :memberships
end

class Idea < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end

class Membership < ActiveRecord::Base
  belongs_to :memberable, :polymorphic => true

  belongs_to :user
  belongs_to :role  
end


Delayed::Worker.backend = :active_record

# Add this directory so the ActiveSupport autoloading works
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

# Add this to simulate Railtie initializer being executed
#ActionMailer::Base.send(:extend, Delayed::DelayMail)

require 'digest_mailer'

Dir[File.dirname(__FILE__)+"/factories/*.rb"].each {|file| require file }

module DelayedJobSpecHelper
  def work_off
    Delayed::Job.all.each do |job|
      job.payload_object.perform
      job.destroy
    end
  end
end