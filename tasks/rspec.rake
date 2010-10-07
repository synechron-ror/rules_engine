ENV['BUNDLE_GEMFILE'] = File.dirname(__FILE__) + '/../spec/rails_3_0_0_root/Gemfile'

require 'rake'
require 'rake/testtask'
require 'rspec'
require 'rspec/core/rake_task'


desc "Run the test suite"
task :spec => ['spec:setup', 'spec:rules_engine_lib', 'spec:rules_engine_view', 'spec:model', 'spec:routing', 'spec:controller', 'spec:cleanup']

namespace :spec do
  desc "Setup the test environment"
  task :setup do
    rules_engine_rails_path = File.expand_path(File.dirname(__FILE__) + '/../spec/rails_3_0_0_root')

    system "cd #{rules_engine_rails_path} && bundle install"
    system "cd #{rules_engine_rails_path} && ./script/rails generate rules_engine:install"
  end
  
  desc "Cleanup the test environment"
  task :cleanup do
    rules_engine_rails_path = File.expand_path(File.dirname(__FILE__) + '/../spec/rails_3_0_0_root')
    
    FileUtils.rm_rf("#{rules_engine_rails_path}/public/stylesheets/rules_engine")
    FileUtils.rm_rf("#{rules_engine_rails_path}/public/stylesheets/application.css")
    FileUtils.rm_rf("#{rules_engine_rails_path}/public/javascripts/rules_engine")
    FileUtils.rm_rf("#{rules_engine_rails_path}/config/initializers/rules_engine.rb")
    FileUtils.rm_rf("#{rules_engine_rails_path}/config/initializers/rules_engine.rb")
    FileUtils.rm_rf("#{rules_engine_rails_path}/db/migrate/20100308225008_create_rules_engine.rb")
    FileUtils.rm_rf("#{rules_engine_rails_path}/doc/README.rules_engine")
    FileUtils.rm_rf("#{rules_engine_rails_path}/doc/README.rules_engine_view")
    FileUtils.rm_rf("#{rules_engine_rails_path}/Gemfile.lock")
  end

  desc "Test the rules_engine library"
  RSpec::Core::RakeTask.new(:rules_engine_lib) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/lib/rules_engine/**/*_spec.rb'
  end

  desc "Test the rules_engine view helpers"
  RSpec::Core::RakeTask.new(:rules_engine_view) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/lib/rules_engine_view/**/*_spec.rb'
  end

  desc "Test the rules_engine models"
  RSpec::Core::RakeTask.new(:model) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/models/**/*_spec.rb'
  end

  desc "Test the rules_engine routing"
  RSpec::Core::RakeTask.new(:routing) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/routing/**/*_spec.rb'
  end

  desc "Test the rules_engine controller helpers"
  RSpec::Core::RakeTask.new(:controller) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/controllers/**/*_spec.rb'
  end

  desc "Run the coverage report"
  RSpec::Core::RakeTask.new(:rcov) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/lib/**/*_spec.rb'
    task.rcov=true
    task.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
  end
end

