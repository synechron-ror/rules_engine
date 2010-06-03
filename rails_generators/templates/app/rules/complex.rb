class Complex < RulesEngine::Rule

  COMPLEX_VERSION = 1.0  
  
  self.options = 
    {
      :group => 'Sample Rules',
      :name => 'Complex',
      :description => 'Does nothing',
      :help_template => '/re_rule_definitions/complex/help',
      :new_template => '/re_rule_definitions/complex/new',
      :edit_template => '/re_rule_definitions/complex/edit'
    } 
  
  attr_reader :title
  attr_reader :words
  attr_reader :pipeline_action
  attr_reader :pipeline
  
  def attributes=(params)
    @words = []
    @title = params['complex_title']
    
    return if params['complex'].nil?
    params['complex'].each do |key, value| 
      @words << value['word'].downcase unless value['word'].blank? || value['_delete'] == '1'
    end
    
    @pipeline_action = params['complex_pipeline_action'] || 'continue'
    @pipeline = params['complex_pipeline'] || ''    
  end
  
  def valid?
    self.errors << "At least one word must be defined" if @words.nil? || @words.empty?
    self.errors << "Title required" if @title.blank?    
    self.errors << "Pipeline required" if @pipeline_action == 'start_pipeline' && @pipeline.blank?
    return self.errors.empty?
  end

  def load(re_rule)
    return false unless super
    
    @title = re_rule.title
    @words, @pipeline_action, @pipeline = ActiveSupport::JSON.decode(re_rule.data)
    true
  end

  def save(re_rule)
    return false unless super
    
    re_rule.title = @title
    re_rule.summary = "Complex #{@words.size} #{@words.size == 1 ? 'word' : 'words'}"
    re_rule.data_version = COMPLEX_VERSION
    re_rule.data = [@words, @pipeline_action, @pipeline].to_json
    re_rule.error = nil
    
    # save rule outcomes    
    if @pipeline_action == 'next'
      re_rule.re_rule_expected_outcomes = [ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)]
    elsif @pipeline_action == 'stop_success'
      re_rule.re_rule_expected_outcomes = [ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)]
    elsif @pipeline_action == 'stop_failure'
      re_rule.re_rule_expected_outcomes = [ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)]
    else # if @pipeline_action == 'start_pipeline'
      re_rule.re_rule_expected_outcomes = [ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, 
                                                    :pipeline_code => @pipeline)]
    end
    
    true
  end    

  def process(job_id, data)
    rule_outcome = RulesEngine::RuleOutcome.new
  
    if @pipeline_action == 'next'
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_NEXT
    elsif @pipeline_action == 'stop_success'
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
    elsif @pipeline_action == 'stop_failure'
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
    else # if @pipeline_action == 'start_pipeline'
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
      rule_outcome.pipeline_code = @pipeline  
    end
    
    rule_outcome
  end  
    
end
