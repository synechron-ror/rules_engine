class RulesEngineComplexManifest
  def self.populate_record(m)

    %w(
      app/rules
      app/views/re_rule_definitions/complex_rule
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      app/views/re_rule_definitions/complex_rule/_title.html.erb
      app/rules/complex_rule.rb
      app/views/re_rule_definitions/complex_rule/_pipeline.html.erb
      app/views/re_rule_definitions/complex_rule/_script.html.erb
      app/views/re_rule_definitions/complex_rule/_help.html.erb
      app/views/re_rule_definitions/complex_rule/_new.html.erb
      app/views/re_rule_definitions/complex_rule/_edit.html.erb
      spec/lib/rules/complex_rule_spec.rb
      app/views/re_rule_definitions/complex_rule/_words.html.erb
      app/views/re_rule_definitions/complex_rule/_word.html.erb
    ).each do |filename|
      m.file filename, filename
    end

  end
end
