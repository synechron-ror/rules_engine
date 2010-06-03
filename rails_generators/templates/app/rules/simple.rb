class Simple < RulesEngine::Rule

  SIMPLE_VERSION = 1.0  
  
  self.options = 
    {
      :group => 'Sample Rules',
      :name => 'Simple Rule',
      :description => 'Does nothing',
      :help_template => '/re_rule_definitions/simple/help',
      :new_template => '/re_rule_definitions/simple/new',
      :edit_template => '/re_rule_definitions/simple/edit'
    } 
  
  attr_reader :title
  
  def attributes=(params)
    @title = params['simple_title']
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
    re_rule.summary = "Simple Rule : Does Nothing"
    re_rule.data_version = SIMPLE_VERSION
    re_rule.data = ["ignore"].to_json
    re_rule.error = nil
    true
  end    
    
end
