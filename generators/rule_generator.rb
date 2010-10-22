Dir["#{File.dirname(__FILE__)}/manifests/*.rb"].each {|f| require f}

module RulesEngine
  module Generators

    class RuleGenerator < Rails::Generators::Base
  
      source_root File.expand_path(File.dirname(__FILE__) + "/manifests/templates")      
  
      def initialize(runtime_args, *runtime_options)
        super
        @rule_type = runtime_args[0] unless runtime_args.length < 1
        @rule_name = runtime_args[1].downcase.gsub(/[^a-zA-Z0-9]+/i, '_') unless runtime_args.length < 2
        @rule_class = @rule_name.camelize unless runtime_args.length < 2
      end
  
      def install
        if @rule_type.blank? || @rule_name.blank? 
          puts "    ***************** rule_type and rule_name required ***************** "
        else  
          begin
            manifest = Kernel.const_get("RulesEngine#{@rule_type.classify}Manifest")
            manifest.populate_record(self, @rule_name)
          rescue
            puts "    ***************** Failed to generate rule #{@rule_type.classify}Manifest ***************** "  
          end  
        end
        puts RuleGenerator.description
      end
  
      def self.description
        <<-DESCRIPTION 
        *******************************************************************    
        To create a new rule from the simple or complex templates
        > rails generate rules_engine:rule [rule_type : simple|complex] [rule_name: new_rule_name]    
        Example : 
        > rails generate rules_engine:rule simple my_simple_rule
    
        Or to see other rule templates install the rules_engine_templates gem
        > gem install rules_engine_templates
        *******************************************************************    
        DESCRIPTION
      end      
  
      desc(description)

      protected
        def rule_name
          @rule_name
        end

        def rule_class
          @rule_class
        end
    end      
  end
end    