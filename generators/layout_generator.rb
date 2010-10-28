module RulesEngine
  module Generators
    class LayoutGenerator < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      def initialize(runtime_args, *runtime_options)
        super
        @layout_name = runtime_args[0] if runtime_args.length > 0
      end

      def install
        if @layout_name.blank?
          puts "**** ERROR : parameter layout_name required"
          puts LayoutGenerator.description
          return
        end

        template "app/views/layouts/rules_engine_layout.html.erb", "app/views/layouts/#{layout_name}.html.erb"

        puts LayoutGenerator.description
      end

      def self.description
        <<-DESCRIPTION
*******************************************************************
To add the rules engine layout to you application
script/rails generate rules_engine:layout [layout_name]
*******************************************************************
        DESCRIPTION
      end

      desc(description)

      protected

        def layout_name
          @layout_name
        end
    end
  end
end
