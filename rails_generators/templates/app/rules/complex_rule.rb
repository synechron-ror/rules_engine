class <%=rule_class%>Rule < RulesEngine::Rule

  attr_reader :words
  attr_reader :workflow_action
  attr_reader :workflow

  ##################################################################
  # class options
  self.options = 
    {
      :group => '<%=rule_class%>',
      :display_name => '<%=rule_class%>',    
      :help_partial => '/re_rule_definitions/<%=rule_name%>_rule/help',
      :new_partial => '/re_rule_definitions/<%=rule_name%>_rule/new',
      :edit_partial => '/re_rule_definitions/<%=rule_name%>_rule/edit'
    } 
  
  ##################################################################
  # set the rule data
  def data= data
    if data.nil?
      @title = nil
      @words = nil
      @workflow_action = 'continue'
      @workflow = nil
    else
      @title, @words, @workflow_action, @workflow = ActiveSupport::JSON.decode(data)
    end  
  end
  
  ##################################################################
  # get the rule attributes
  def title
    @title
  end

  def summary
    "Match the #{words.size == 1 ? 'word' : 'words'} #{words.join(', ')}"
  end
  
  def data
    [title, words, workflow_action, workflow].to_json
  end
  
  def expected_outcomes
    case workflow_action    
    when 'next'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    when 'stop_success'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS]
    when 'stop_failure'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE]
    when 'start_workflow'
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW, :workflow_code => workflow]
    else
      [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]  
    end
  end
  
  ##################################################################
  # set the rule attributes
  def attributes=(params)
    param_hash = params.symbolize_keys

    @title = param_hash[:<%=rule_name%>_title]
    
    @words = []
    return if param_hash[:<%=rule_name%>_words].nil?
    param_hash[:<%=rule_name%>_words].each do |key, values| 
      if values.is_a?(Hash)
        word_hash = values.symbolize_keys
        @words << word_hash[:word].downcase unless word_hash[:word].blank? || word_hash[:_delete] == '1'
      end  
    end
    
    @workflow_action = param_hash[:<%=rule_name%>_workflow_action] || 'continue'
    @workflow = param_hash[:<%=rule_name%>_workflow] || ''
  end
  
  ##################################################################
  # validation and errors
  def valid?
    @errors = {}
    @errors[:<%=rule_name%>_words] = "At least one word must be defined" if words.nil? || words.empty?
    @errors[:<%=rule_name%>_title] = "Title required" if title.blank?    
    @errors[:<%=rule_name%>_workflow] = "Workflow required" if workflow_action == 'start_workflow' && workflow.blank?
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
  # it gets the data parameter :sentence
  # it sets the data parameter :match
  def process(process, data)
    sentence = data[:sentence] || data["sentence"]    
    if sentence.blank?
      return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT) 
    end
    
    words.each do |word|
      if /#{word}/i =~ sentence        
        process.audit("#{title} Found #{word}", RulesEngine::Audit::AUDIT_INFO)
        data[:match] = word
        
        case workflow_action
        when 'stop_success'
          return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
        when 'stop_failure'
          return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
        when 'start_workflow'
          return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW, workflow)
        else #'next'
          return RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT)
        end
      end
    end
        
    RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT)
  end  
    
end
