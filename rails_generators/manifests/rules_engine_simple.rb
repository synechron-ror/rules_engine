class RulesEngineSimpleManifest
  def self.populate_record(m)

    %w(
      app/rules
      app/views/re_rule_definitions/simple
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      app/views/re_rule_definitions/simple/_new.html.erb
      app/views/re_rule_definitions/simple/_edit.html.erb
      app/rules/simple.rb
      app/views/re_rule_definitions/simple/_help.html.erb
    ).each do |filename|
      m.file filename, filename
    end

  end
end
