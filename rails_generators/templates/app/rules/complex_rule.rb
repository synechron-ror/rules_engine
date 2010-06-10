class ComplexRule < RulesEngine::Rule

  self.options = 
    {
      :group => 'Sample Rules',
      :display_name => 'Complex Rule',    
      :help_partial => '/re_rule_definitions/complex_rule/help',
      :new_partial => '/re_rule_definitions/complex_rule/new',
      :edit_partial => '/re_rule_definitions/complex_rule/edit'
    } 
  
  attr_reader :words
  attr_reader :pipeline_action
  attr_reader :pipeline

  ##################################################################
  def title
    @title
  end

  def summary
    "Complex #{@words.size} #{@words.size == 1 ? 'word' : 'words'}"
  end
  
  def data
    [@title, @words, @pipeline_action, @pipeline].to_json
  end
  
  def data= data
    if data.nil?
      @title = ''
      @words = nil
      @pipeline_action = 'continue'
      @pipeline = nil
    else
      @title, @words, @pipeline_action, @pipeline = ActiveSupport::JSON.decode(data)
    end  
  end
  
  def expected_outcomes
    if @pipeline_action == 'next'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    elsif @pipeline_action == 'stop_success'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS]
    elsif @pipeline_action == 'stop_failure'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE]
    else # if @pipeline_action == 'start_pipeline'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => @pipeline]
    end
  end
  
  ##################################################################
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
  
  ##################################################################
  def valid?
    @errors = {}
    self.errors[:words] = "At least one word must be defined" if @words.nil? || @words.empty?
    self.errors[:title] = "Title required" if @title.blank?    
    self.errors[:pipeline] = "Pipeline required" if @pipeline_action == 'start_pipeline' && @pipeline.blank?
    return self.errors.empty?
  end

  ##################################################################
  def after_create(rule_id)
  end
  
  def before_destroy(rule_id)
  end
  
  ##################################################################
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
