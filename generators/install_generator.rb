require "#{File.dirname(__FILE__)}/manifests/application.rb"

module RulesEngine
  module Generators
    class InstallGenerator < Rails::Generators::Base
  
      source_root File.expand_path(File.dirname(__FILE__) + "/manifests/templates")      
  
      def initialize(runtime_args, *runtime_options)
        super
      end
  
      def install
        ApplicationManifest.populate_record(self, "rules_engine")
        puts InstallGenerator.description_all
      end
  
      def self.description_all
        <<-DESCRIPTION 
        *******************************************************************    
        To add the rules engine to you application
        > script/rails generate rules_engine:install

        To create a new rule from the simple or complex templates
        > script/rails generate rules_engine:rule [simple|complex] [new_rule_name]    
        Example : 
        > script/rails generate rules_engine:rule simple my_simple_rule
    
        Or to see other rule templates install the rules_engine_templates gem
        > gem install rules_engine_templates
        *******************************************************************    
        DESCRIPTION
      end      
  
      desc(description_all)
    end      
  end
end    