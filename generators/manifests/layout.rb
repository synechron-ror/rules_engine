module RulesEngine
  module Generators
    class LayoutManifest
      def self.populate_record(m, rule_name)

        %W(
        ).each do |dirname|
          m.empty_directory dirname
        end

        %W(
        ).each do |filename|
          m.copy_file filename, filename
        end

       m.template "app/views/layouts/rules_engine.html.erb",  "app/views/layouts/rules_engine.html.erb"

      end
    end
  end
end
