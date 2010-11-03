module RulesEngine
  module Generators
    class SimpleGenerator < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      def initialize(runtime_args, *runtime_options)
        super
        @rule_name = runtime_args[0] if runtime_args.length > 0
      end

      def install
        if @rule_name.blank?
          puts "**** ERROR : parameter rule_name required"
          puts SimpleGenerator.description
          return
        end

        template "app/rules/simple.rb", "app/rules/#{rule_name}.rb"
        template "app/views/re_rules/simple/_edit.html.erb", "app/views/re_rules/#{rule_name}/_edit.html.erb"
        template "app/views/re_rules/simple/_form.html.erb", "app/views/re_rules/#{rule_name}/_form.html.erb"
        template "app/views/re_rules/simple/_help.html.erb", "app/views/re_rules/#{rule_name}/_help.html.erb"
        template "app/views/re_rules/simple/_new.html.erb", "app/views/re_rules/#{rule_name}/_new.html.erb"
        template "spec/lib/rules/simple_spec.rb", "spec/lib/rules/#{rule_name}_spec.rb"

        puts SimpleGenerator.description
      end

      def self.description
        <<-DESCRIPTION
*******************************************************************
To create a new rule from the simple rule template
rails generate rules_engine:simple [rule_name]

Example
rails generate rules_engine:simple my_cool_rule

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
    end
  end
end
