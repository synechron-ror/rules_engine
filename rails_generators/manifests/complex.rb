class ComplexManifest
  def self.populate_record(m, rule_name ,rule_class)

    %W(
      app/rules
      app/views/re_rules/#{rule_name}
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %W(
    ).each do |filename|
      m.file filename, filename
    end

   m.template "app/rules/complex.rb",  "app/rules/#{rule_name}.rb"
   m.template "app/views/re_rules/complex/_edit.html.erb",  "app/views/re_rules/#{rule_name}/_edit.html.erb"
   m.template "app/views/re_rules/complex/_form.html.erb",  "app/views/re_rules/#{rule_name}/_form.html.erb"
   m.template "app/views/re_rules/complex/_form_word.html.erb",  "app/views/re_rules/#{rule_name}/_form_word.html.erb"
   m.template "app/views/re_rules/complex/_help.html.erb",  "app/views/re_rules/#{rule_name}/_help.html.erb"
   m.template "app/views/re_rules/complex/_new.html.erb",  "app/views/re_rules/#{rule_name}/_new.html.erb"
   m.template "spec/lib/rules/complex_spec.rb",  "spec/lib/rules/#{rule_name}_spec.rb"

  end

  def self.after_generate(rule_name ,rule_class)
  end

end
