class RuleTweetFilterManifest
  def self.populate_record(m)

    %W(
      app/rules
      app/views/re_rule_definitions/rule_tweet_filter
      lib/tasks
      spec/lib/rules
    ).each do |dirname|
      m.directory dirname
    end

    %W(
      app/rules/rule_tweet_filter.rb
      app/views/re_rule_definitions/rule_tweet_filter/_edit.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_help.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_new.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_script.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_title.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_word.html.erb
      app/views/re_rule_definitions/rule_tweet_filter/_words.html.erb
      spec/lib/rules/rule_tweet_filter_spec.rb
    ).each do |filename|
      m.file filename, filename
    end


  end
end
