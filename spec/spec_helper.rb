# The minimal Rails project was created to run specs against using:
# rails -m http://github.com/robinsp/rails_templates/raw/master/minimal.rb railsenv


ENV["RAILS_ENV"] = "test"

require File.expand_path(File.dirname(__FILE__) + "/railsenv/config/environment")
require 'spec'
require 'spec/rails'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  # config.mock_with :mocha
end

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/railsenv/log/debug.log")


Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each {|f| require f}

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_published_plans do |t|
    t.string   :plan_code
    t.integer  :plan_version
    t.string   :version_tag
          
    t.datetime :published_at
    t.text     :data
  end
end

# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_process_runs do |t|
    t.string   :plan_code
    t.integer  :process_status
    t.datetime :created_at
    t.datetime :started_at
    t.datetime :finished_at
  end
end

ActiveRecord::Schema.define(:version => 1) do
  create_table :re_process_audits do |t|
    t.integer  :process_id
          
    t.datetime :created_at
    t.integer  :code
    t.string   :message            
  end    
end