class <%=rule_class%>Rule < RulesEngine::Rule

  attr_reader :description
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
    description
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
    @errors[:<%=rule_name%>_description] = "Description required" if description.blank?    
    return @errors.empty?
  end

  ##################################################################
  # callbacks when the rule is added and removed from a pipeline
  def after_add_to_pipeline(re_pipeline_id, re_rule_id)
  end
  
  def before_remove_from_pipeline(re_pipeline_id, re_rule_id)
  end
  
  ##################################################################
  # execute the rule
  # this rule does nothing
  def process(job, data)
    job.audit("Inside Rule #{title}", ReJobAudit::AUDIT_INFO)                        
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
    # RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, 'next_pipeline')
    RulesEngine::RuleOutcome.new(RulesEngine::RuleOutcome::OUTCOME_NEXT)
  end  
end
