class BlacklistWordManifest
  def self.populate_record(m)

    %w(
      app/rules
      app/views/re_rule_definitions/blacklist_word
    ).each do |dirname|
      m.directory dirname
    end

    %w(
      app/rules/blacklist_word.rb
      app/views/re_rule_definitions/blacklist_word/_pipeline.html.erb
      app/views/re_rule_definitions/blacklist_word/_title.html.erb
      app/views/re_rule_definitions/blacklist_word/_new.html.erb
      app/views/re_rule_definitions/blacklist_word/_help.html.erb
      app/views/re_rule_definitions/blacklist_word/_word.html.erb
      app/views/re_rule_definitions/blacklist_word/_script.html.erb
      app/views/re_rule_definitions/blacklist_word/_edit.html.erb
      app/views/re_rule_definitions/blacklist_word/_words.html.erb
    ).each do |filename|
      m.file filename, filename
    end

  end
end
