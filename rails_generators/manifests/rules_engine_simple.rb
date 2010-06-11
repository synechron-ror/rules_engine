class RulesEngineSimpleManifest
  def self.populate_record(m)

    %w(
      app/views/re_rule_definitions/simple_rule
      app/rules
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      app/views/re_rule_definitions/simple_rule/_edit.html.erb
      app/views/re_rule_definitions/simple_rule/_title.html.erb
      spec/lib/rules/simple_rule_spec.rb
      app/views/re_rule_definitions/simple_rule/_new.html.erb
      app/rules/simple_rule.rb
      app/views/re_rule_definitions/simple_rule/_help.html.erb
    ).each do |filename|
      m.file filename, filename
    end

  end
end
