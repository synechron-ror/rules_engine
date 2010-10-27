module RulesEngine
  module Generators
    class SimpleGenerator < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      def initialize(runtime_args, *runtime_options)
        super
        @rule_name = runtime_args[0] if runtime_args.length > 0
        @rule_class = runtime_args[1] if runtime_args.length > 1
      end

      def install
        throw("parameter rule_name required") if @rule_name.blank?
        throw("parameter rule_class required") if @rule_class.blank?

        template "app/rules/simple.rb", "app/rules/#{rule_name}.rb"
        template "app/views/re_rules/simple/_edit.html.erb", "app/views/re_rules/#{rule_name}/_edit.html.erb"
        template "app/views/re_rules/simple/_form.html.erb", "app/views/re_rules/#{rule_name}/_form.html.erb"
        template "app/views/re_rules/simple/_help.html.erb", "app/views/re_rules/#{rule_name}/_help.html.erb"
        template "app/views/re_rules/simple/_new.html.erb", "app/views/re_rules/#{rule_name}/_new.html.erb"
        template "spec/lib/rules/simple_spec.rb", "spec/lib/rules/#{rule_name}_spec.rb"

        SimpleGenerator.description
      end

      def self.description
        <<-DESCRIPTION
*******************************************************************
To create a new rule from the simple rule template
rails generate rules_engine:simple [rule_name] [RuleName]    

Example
rails generate rules_engine:simple my_cool_rule MyCoolRule

Or to see other rule templates install the rules_engine_templates gem
gem install rules_engine_templates
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
