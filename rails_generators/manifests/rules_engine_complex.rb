class RulesEngineComplexManifest
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

   m.template "app/rules/complex_rule.rb",  "app/rules/#{rule_name}_rule.rb"
   m.template "app/views/re_rule_definitions/complex_rule/_edit.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_edit.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_help.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_help.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_new.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_pipeline.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_pipeline.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_script.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_script.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_title.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_title.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_word.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_word.html.erb"
   m.template "app/views/re_rule_definitions/complex_rule/_words.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_words.html.erb"
   m.template "lib/tasks/re_complex_rule.rake",  "lib/tasks/re_#{rule_name}_rule.rake"
   m.template "spec/lib/rules/complex_rule_spec.rb",  "spec/lib/rules/#{rule_name}_rule_spec.rb"

  end
end
