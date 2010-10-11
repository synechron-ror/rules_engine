require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rules_engine"
    gem.summary = %Q{Rules engine}
    gem.description = %Q{Ruby Rails Rules Engine Framework : R3EF}
    gem.email = "dougo.chris@gmail.com"
    gem.homepage = "http://github.com/dougochris/rules_engine"
    gem.authors = ["Chris Douglas"]
    gem.add_dependency 'will_paginate', '>= 3.0.pre2'
    gem.add_dependency 'acts_as_list', '>= 0.1.2'
    gem.add_development_dependency "rspec-rails", ">= 2.0.0"
    gem.add_development_dependency "webrat"
    gem.add_development_dependency 'faker'
    gem.add_development_dependency'machinist'  
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.files = FileList['app/**/*', 'autotest/**/*', 'config/**/*', 'generators/**/*', 'lib/**/*', 'spec/**/*', 'tasks/**/*', 'init.rb', 'LICENSE', 'README.textile', 'VERSION']
    gem.post_install_message = %q{
      *** RUN script/rails generate rules_engine:install --help
    }
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

# require 'spec/rake/spectask'
# Spec::Rake::SpecTask.new(:spec) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.spec_files = FileList['spec/**/*_spec.rb']
# end
# 
# Spec::Rake::SpecTask.new(:rcov) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end
# 
# task :spec => :check_dependencies
# 
# task :default => :spec
# 
# require 'rake/rdoctask'
# Rake::RDocTask.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
# 
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "rules_engine #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
