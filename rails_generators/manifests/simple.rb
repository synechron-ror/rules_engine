class SimpleManifest
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

   m.template "app/rules/simple.rb",  "app/rules/#{rule_name}.rb"
   m.template "app/views/re_rule_definitions/simple/_edit.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_edit.html.erb"
   m.template "app/views/re_rule_definitions/simple/_form.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_form.html.erb"
   m.template "app/views/re_rule_definitions/simple/_help.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_help.html.erb"
   m.template "app/views/re_rule_definitions/simple/_new.html.erb",  "app/views/re_rule_definitions/#{rule_name}/_new.html.erb"
   m.template "spec/lib/rules/simple_spec.rb",  "spec/lib/rules/#{rule_name}_spec.rb"

  end
end
