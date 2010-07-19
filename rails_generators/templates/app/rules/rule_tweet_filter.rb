class RuleTweetFilter < RulesEngine::Rule

  attr_reader :words

  ##################################################################
  # class options
  self.options = 
    {
      :group => 'Twitter',
      :display_name => 'Twitter Filter',    
      :help_partial => '/re_rule_definitions/rule_tweet_filter/help',
      :new_partial => '/re_rule_definitions/rule_tweet_filter/new',
      :edit_partial => '/re_rule_definitions/rule_tweet_filter/edit'
    } 
  
  ##################################################################
  # set the rule data
  def data= data
    if data.nil?
      @title = nil
      @words = nil
    else
      @title, @words = ActiveSupport::JSON.decode(data)
    end  
  end
  
  ##################################################################
  # get the rule attributes
  def title
    @title
  end

  def summary
    "Filter out tweets with the #{words.size == 1 ? 'word' : 'words'} #{words.join(', ')}"
  end
  
  def data
    [title, words].to_json
  end
  
  def expected_outcomes
      [{:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT}, {:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS}]
  end
  
  ##################################################################
  # set the rule attributes
  def attributes=(params)
    param_hash = params.symbolize_keys

    @title = param_hash[:tweet_filter_title]
    
    @words = []
    return if param_hash[:tweet_filter_words].nil?
    param_hash[:tweet_filter_words].each do |key, values| 
      if values.is_a?(Hash)
        word_hash = values.symbolize_keys
        @words << word_hash[:word].downcase unless word_hash[:word].blank? || word_hash[:_delete] == '1'
      end  
    end
  end
  
  ##################################################################
  # validation and errors
  def valid?
    @errors = {}
    @errors[:tweet_filter_words] = "At least one word must be defined" if words.nil? || words.empty?
    @errors[:tweet_filter_title] = "Title required" if title.blank?    
    return @errors.empty?
  end

  ##################################################################
  # callbacks when the rule is added and removed from a workflow
  def after_add_to_workflow(workflow_code)
  end
  
  def before_remove_from_workflow(workflow_code)
  end
  
  ##################################################################
  # execute the rule
  # if a match is found procees to the expected outcome
  # it gets the data parameter :tweet
  # it sets the data parameter :match
  def process(process_id, data)
    tweet = data[:tweet] || data["tweet"]    
    if tweet.blank?
      return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT) 
    end
    
    words.each do |word|
      if /#{word}/i =~ tweet        
        RulesEngine::Process.auditor.audit(process_id, "#{title} Found #{word}", RulesEngine::Process::AUDIT_INFO)
        data[:match] = word
        return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
      end
    end
        
    RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT)
  end  
    
end
