class <%=rule_class%>Rule < RulesEngine::Rule

  ##################################################################
  # class options
  self.options = 
    {
      :group => '<%=rule_class%> Rules',
      :display_name => '<%=rule_class%> Rule',    
      :help_partial => '/re_rule_definitions/<%=rule_name%>_rule/help',
      :new_partial => '/re_rule_definitions/<%=rule_name%>_rule/new',
      :edit_partial => '/re_rule_definitions/<%=rule_name%>_rule/edit'
    } 
  
  ##################################################################
  # set the rule data
  def data= data
    if data.nil?
      @title = nil
    else
      @title = data
    end  
  end
  
  ##################################################################
  # get the rule attributes
  def title
    @title
  end
  
  def summary
    "Does Nothing, called #{title}"
  end
  
  def data
    title
  end
  
  def expected_outcomes
    []
  end
  
  ##################################################################
  # set the rule attributes
  def attributes=(params)
    param_hash = params.symbolize_keys

    @title = param_hash[:<%=rule_name%>_title]
  end
  
  ##################################################################
  # validation and errors
  def valid?
    @errors = {}
    @errors[:<%=rule_name%>_title] = "Title required" if title.blank?    
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
  def process(job_id, data)
    return nil
  end  
end
