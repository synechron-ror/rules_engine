require "#{File.dirname(__FILE__)}/manifests/rules_engine_layout.rb"

module RulesEngine
  module Generators
    class LayoutGenerator < Rails::Generators::Base
  
      source_root File.expand_path(File.dirname(__FILE__) + "/manifests/templates")      
  
      def initialize(runtime_args, *runtime_options)
        super        
        @layout_name = runtime_args[0] unless runtime_args.length < 1
      end
  
      def install
        if @layout_name.blank? 
          puts "    ***************** layout_name required ***************** "
        else  
          RulesEngineLayoutManifest.populate_record(self, @layout_name)
        end  
        puts LayoutGenerator.description
      end
  
      def self.description
        <<-DESCRIPTION 
        *******************************************************************    
        To add the rules engine layout to you application
        > script/rails generate rules_engine:layout [layout_name]
        
        *******************************************************************    
        DESCRIPTION
      end      
  
      desc(description)
    end      
  end
end    