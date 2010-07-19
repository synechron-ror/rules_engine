class <%=rule_class%> < RulesEngine::Rule

  attr_reader :description
  ##################################################################
  # class options
  self.options = 
    {
      :group => 'General',
      :display_name => '<%=rule_class%> Rule',    
      :help_partial => '/re_rule_definitions/<%=rule_name%>/help',
      :new_partial => '/re_rule_definitions/<%=rule_name%>/new',
      :edit_partial => '/re_rule_definitions/<%=rule_name%>/edit'
    } 
  
  ##################################################################
  # set the rule data
  def data= data
    if data.nil?
      @title = nil
      @description = nil
    else
      @title, @description = ActiveSupport::JSON.decode(data)
    end  
  end
  
  ##################################################################
  # get the rule attributes
  def title
    @title
  end
  
  def summary
    description || "Does Nothing"
  end
  
  def data
    [title, description].to_json
  end
  
  def expected_outcomes
    [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
  end
  
  ##################################################################
  # set the rule attributes
  def attributes=(params)
    param_hash = params.symbolize_keys

    @title = param_hash[:<%=rule_name%>_title]
    @description = param_hash[:<%=rule_name%>_description]
  end
  
  ##################################################################
  # validation and errors
  def valid?
    @errors = {}
    @errors[:<%=rule_name%>_title] = "Title required" if title.blank?    
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
  # this rule does nothing
  def process(process_id, data)
    RulesEngine::Process.auditor.audit(process_id, "Inside Rule #{title}", RulesEngine::Process::AUDIT_INFO)                        
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW, 'next_workflow')
    RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT)
  end  
end
