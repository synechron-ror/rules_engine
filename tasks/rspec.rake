ENV['BUNDLE_GEMFILE'] = File.dirname(__FILE__) + '/../spec/rails_3_0_0_root/Gemfile'

require 'rake'
require 'rake/testtask'
require 'rspec'
require 'rspec/core/rake_task'

namespace :spec do
  desc "Setup the test environment"
  task :setup do
    system "cd spec && bundle install"
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

  desc "Run the coverage report"
  RSpec::Core::RakeTask.new(:rcov) do |task|
    rules_engine_root = File.expand_path(File.dirname(__FILE__) + '/..')
    task.pattern = rules_engine_root + '/spec/lib/**/*_spec.rb'
    task.rcov=true
    task.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
  end


  # desc "Run the test suite"
  # task :default => ['spec:lib'] # , 'spec:basic', 'spec:features', 'spec:views', 'spec:features_for_views']
  
  # Spec::Rake::SpecTask.new(:basic => %w(spec:generator:cleanup spec:generator:rules_engine)) do |task|
  #   task.spec_files = FileList['spec/*/*_spec.rb']
  # end
  # 
  # Spec::Rake::SpecTask.new(:views => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_views)) do |task|
  #   task.spec_files = FileList['spec/*/*_spec.rb']
  # end
  # 
  # Cucumber::Rake::Task.new(:features => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_features)) do |task|
  #   task.cucumber_opts = '--format progress'
  #   task.profile = 'features_with_rspec'
  # end
  # 
  # Cucumber::Rake::Task.new(:features_for_views => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_features spec:generator:clearance_views)) do |task|
  #   task.cucumber_opts = '--format progress'
  #   task.profile = 'features_for_views_with_rspec'
  # end

  # namespace :generator do
  #   task :cleanup do
  #     FileList["spec/rails_root/db/**/*"].each do |each|
  #       FileUtils.rm_rf(each)
  #     end
  # 
  #     FileUtils.rm_rf("spec/rails_root/vendor/plugins/clearance")
  #     FileUtils.rm_rf("spec/rails_root/app/views/passwords")
  #     FileUtils.rm_rf("spec/rails_root/app/views/sessions")
  #     FileUtils.rm_rf("spec/rails_root/app/views/users")
  #     FileUtils.mkdir_p("spec/rails_root/vendor/plugins")
  #     clearance_root = File.expand_path(File.dirname(__FILE__))
  #     system("ln -s #{clearance_root} spec/rails_root/vendor/plugins/clearance")
  #     FileList["spec/rails_root/features/*.feature"].each do |each|
  #       FileUtils.rm_rf(each)
  #     end
  #   end

    # task :clearance do
    #   system "cd spec/rails_root && bundle install && ./script/rails generate clearance && rake db:migrate db:test:prepare"
    # end
    # 
    # task :clearance_features do
    #   system "cd spec/rails_root && ./script/rails generate clearance_features"
    # end
    # 
    # task :clearance_views do
    #   system "cd spec/rails_root && ./script/rails generate clearance_views"
    # end
  # end
end

# namespace :generator do
#   desc "Cleans up the test app before running the generator"
#   task :cleanup do
#     FileList["test/rails_root/db/**/*"].each do |each|
#       FileUtils.rm_rf(each)
#     end
# 
#     FileUtils.rm_rf("test/rails_root/app/views/passwords")
#     FileUtils.rm_rf("test/rails_root/app/views/sessions")
#     FileUtils.rm_rf("test/rails_root/app/views/users")
#     FileUtils.mkdir_p("test/rails_root/vendor/plugins")
#     clearance_root = File.expand_path(File.dirname(__FILE__))
#     FileList["test/rails_root/features/*.feature"].each do |each|
#       FileUtils.rm_rf(each)
#     end
#   end
# 
#   desc "Run the clearance generator"
#   task :clearance do
#     system "cd test/rails_root && bundle install && ./script/rails generate clearance && rake db:migrate db:test:prepare"
#   end
# 
#   desc "Run the clearance features generator"
#   task :clearance_features do
#     system "cd test/rails_root && ./script/rails generate clearance_features"
#   end
# 
#   desc "Run the clearance views generator"
#   task :clearance_views do
#     system "cd test/rails_root && ./script/rails generate clearance_views"
#   end
# end
# 

