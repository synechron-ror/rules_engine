class RulesEngineComplexManifest
  def self.populate_record(m)

    %w(
      app/views/re_rule_definitions/complex
      app/rules
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      app/rules/complex.rb
      app/views/re_rule_definitions/complex/_help.html.erb
      app/views/re_rule_definitions/complex/_script.html.erb
      app/views/re_rule_definitions/complex/_edit.html.erb
      app/views/re_rule_definitions/complex/_new.html.erb
      app/views/re_rule_definitions/complex/_word.html.erb
      app/views/re_rule_definitions/complex/_words.html.erb
      app/views/re_rule_definitions/complex/_title.html.erb
      app/views/re_rule_definitions/complex/_pipeline.html.erb
    ).each do |filename|
      m.file filename, filename
    end

  end
end
