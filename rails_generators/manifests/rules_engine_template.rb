class RulesEngineTemplateManifest
  def self.populate_record(m, rule_name)

    m.directory "app/views/re_rule_definitions/#{rule_name}"
    
    m.template "app/views/re_rule_definitions/template/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_new.html.erb"
    m.template "app/views/re_rule_definitions/template/_edit.html.erb", "app/views/re_rule_definitions/#{rule_name}/_edit.html.erb"
    m.template "app/views/re_rule_definitions/template/_help.html.erb", "app/views/re_rule_definitions/#{rule_name}/_help.html.erb"
    
    m.template "app/rules/template.rb", "app/rules/#{rule_name}.rb"

  end
end
