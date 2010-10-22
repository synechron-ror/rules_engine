require "rules_engine"
require "rails"

module RulesEngine
  class Engine < Rails::Engine
      
    rake_tasks do
      load File.expand_path(File.dirname(__FILE__) + "./../../tasks/rules_engine.rake")
    end    
    
    generators do
      require File.expand_path(File.dirname(__FILE__) + "./../../generators/install_generator")
      require File.expand_path(File.dirname(__FILE__) + "./../../generators/layout_generator")
      require File.expand_path(File.dirname(__FILE__) + "./../../generators/rule_generator")
    end    
  end
end
