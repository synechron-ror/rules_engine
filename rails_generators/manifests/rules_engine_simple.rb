class RulesEngineSimpleManifest
  def self.populate_record(m, rule_name ,rule_class)

    %W(
      app/rules
      app/views/re_rule_definitions/#{rule_name}_rule
      lib/tasks
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %W(
    ).each do |filename|
      m.file filename, filename
    end

   m.template "app/rules/simple_rule.rb",  "app/rules/#{rule_name}_rule.rb"
   m.template "app/views/re_rule_definitions/simple_rule/_edit.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_edit.html.erb"
   m.template "app/views/re_rule_definitions/simple_rule/_form.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_form.html.erb"
   m.template "app/views/re_rule_definitions/simple_rule/_help.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_help.html.erb"
   m.template "app/views/re_rule_definitions/simple_rule/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_new.html.erb"
   m.template "spec/lib/rules/simple_rule_spec.rb",  "spec/lib/rules/#{rule_name}_rule_spec.rb"

  end
end
