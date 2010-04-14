class <%= rule_class %> < RulesEngine::Rule

  <%=rule_name.upcase %>_VERSION = 1.0  
  
  self.options = 
    {
      :group => 'Sample Rules',
      :name => '<%=rule_class %> Rule',
      :description => 'Does nothing',
      :help_template => '/re_rule_definitions/<%=rule_name %>/help',
      :new_template => '/re_rule_definitions/<%=rule_name %>/new',
      :edit_template => '/re_rule_definitions/<%=rule_name %>/edit'
    } 
  
  attr_reader :title
  
  def attributes=(params)
    @title = params['<%=rule_name %>_title']
  end
  
  def valid?
    self.errors << "Title required" if @title.blank?
    return self.errors.empty?
  end

  def load(re_rule)
    return false unless super

    @title = re_rule.title
    true
  end

  def save(re_rule)
    return false unless super

    re_rule.title = @title
    re_rule.summary = "<%=rule_class %> Rule : Does Nothing"
    re_rule.data_version = <%=rule_name.upcase%>_VERSION
    re_rule.data = ["ignore"].to_json
    re_rule.error = nil
    true
  end    

  ##################################################################
  # return an RulesEngine::RuleOutcome object to define what to do next
  # or nil to continue to the next rule
  def process(job_id, data)
    nil 
  end  
    
end
