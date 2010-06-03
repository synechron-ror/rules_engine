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