class ComplexRule < RulesEngine::Rule

  attr_reader :words
  attr_reader :pipeline_action
  attr_reader :pipeline

  ##################################################################
  # class options
  self.options = 
    {
      :group => 'Sample Rules',
      :display_name => 'Find Matching Words',    
      :help_partial => '/re_rule_definitions/complex_rule/help',
      :new_partial => '/re_rule_definitions/complex_rule/new',
      :edit_partial => '/re_rule_definitions/complex_rule/edit'
    } 
  
  ##################################################################
  # set the rule data
  def data= data
    if data.nil?
      @title = nil
      @words = nil
      @pipeline_action = 'continue'
      @pipeline = nil
    else
      @title, @words, @pipeline_action, @pipeline = ActiveSupport::JSON.decode(data)
    end  
  end
  
  ##################################################################
  # get the rule attributes
  def title
    @title
  end

  def summary
    word_size = self.words.size
    "Look for #{word_size} matching #{word_size == 1 ? 'word' : 'words'}"
  end
  
  def data
    [self.title, self.words, self.pipeline_action, self.pipeline].to_json
  end
  
  def expected_outcomes
    case self.pipeline_action    
    when 'next'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    when 'stop_success'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS]
    when 'stop_failure'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE]
    when 'start_pipeline'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => self.pipeline]
    else
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]  
    end
  end
  
  ##################################################################
  # set the rule attributes
  def attributes=(params)
    param_hash = params.symbolize_keys

    @title = param_hash[:complex_title]
    
    @words = []
    return if param_hash[:complex_words].nil?
    param_hash[:complex_words].each do |key, values| 
      if values.is_a?(Hash)
        word_hash = values.symbolize_keys
        @words << word_hash[:word].downcase unless word_hash[:word].blank? || word_hash[:_delete] == '1'
      end  
    end
    
    @pipeline_action = param_hash[:complex_pipeline_action] || 'continue'
    @pipeline = param_hash[:complex_pipeline] || ''
  end
  
  ##################################################################
  # validation and errors
  def valid?
    @errors = {}
    self.errors[:complex_words] = "At least one word must be defined" if self.words.nil? || self.words.empty?
    self.errors[:complex_title] = "Title required" if self.title.blank?    
    self.errors[:complex_pipeline] = "Pipeline required" if self.pipeline_action == 'start_pipeline' && self.pipeline.blank?
    return self.errors.empty?
  end

  ##################################################################
  # callbacks when the rule is added and removed from a pipeline
  def after_add_to_pipeline(re_pipeline_id, re_rule_id)
  end
  
  def before_remove_from_pipeline(re_pipeline_id, re_rule_id)
  end
  
  ##################################################################
  # execute the rule
  # if a match is found procees to the expected outcome
  # it gets the data parameter :sentence
  # it sets the data parameter :match
  def process(job_id, data)
    sentence = data[:sentence]
    return nil if sentence.blank?
    
    self.words.each do |word|
      if /#{word}/i =~ sentence
        data[:match] = word
        rule_outcome = RulesEngine::RuleOutcome.new        
        
        case self.pipeline_action
        when 'stop_success'
          rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
        when 'stop_failure'
          rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
        when 'start_pipeline'
          rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
          rule_outcome.pipeline_code = self.pipeline  
        else #'next'
          rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_NEXT
        end
        
        return rule_outcome
      end
    end
        
    nil
  end  
    
end
