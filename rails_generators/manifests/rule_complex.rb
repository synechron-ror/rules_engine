class RuleComplexManifest
  def self.populate_record(m, rule_name ,rule_class)

    %W(
      app/rules
      app/views/re_rule_definitions/#{rule_name}
      lib/tasks
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %W(
    ).each do |filename|
      m.file filename, filename
    end

   m.template "app/rules/rule_complex.rb",  "app/rules/#{rule_name}.rb"
   m.template "app/views/re_rule_definitions/rule_complex/_edit.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_edit.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_help.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_help.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_new.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_script.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_script.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_title.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_title.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_word.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_word.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_words.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_words.html.erb"
   m.template "app/views/re_rule_definitions/rule_complex/_workflow.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_workflow.html.erb"
   m.template "spec/lib/rules/rule_complex_spec.rb",  "spec/lib/rules/#{rule_name}_spec.rb"

  end
end
