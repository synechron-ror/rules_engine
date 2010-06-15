class RulesEngineTemplateManifest
  def self.populate_record(m, rule_name)

    %W(
      app/views/re_rule_definitions/#{rule_name}_rule
      app/rules
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    m.directory "app/views/re_rule_definitions/#{rule_name}"
    
    m.template "app/rules/template_rule.rb",  "app/rules/#{rule_name}_rule.rb"
      
    m.template "app/views/re_rule_definitions/template_rule/_edit.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_edit.html.erb"
    m.template "app/views/re_rule_definitions/template_rule/_title.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_title.html.erb"
    m.template "app/views/re_rule_definitions/template_rule/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_new.html.erb"
    m.template "app/views/re_rule_definitions/template_rule/_help.html.erb",  "app/views/re_rule_definitions/#{rule_name}_rule/_help.html.erb"      

    m.template "spec/lib/rules/template_rule_spec.rb",  "spec/lib/rules/#{rule_name}_rule_spec.rb"
  end
end
