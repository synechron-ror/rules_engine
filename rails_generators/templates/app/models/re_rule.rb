class ReRule < ActiveRecord::Base
  belongs_to :re_workflow
  acts_as_list :scope => :re_workflow
      
  validates_associated  :re_workflow
  validates_presence_of :rule_class_name

  default_scope :order => 're_rules.position ASC'
  
  before_save    :before_save_rule
  before_destroy :before_destroy_rule

  def before_save_rule
    return if rule.nil?
    
    if self.new_record?
      rule.before_create()
    else  
      rule.before_update()
    end  
    
    self.title = rule.title
    self.summary = rule.summary
    self.data = rule.data
    
    re_workflow.changed! if changes.detect { |change| !ignore_attributes.include?(change[0])}    
  end

  def before_destroy_rule
    rule.before_destroy() unless rule.nil?
  end

  def validate
    if self.rule.nil?
      errors.add("rule_class", "not found")
    elsif !self.rule.valid?
      errors.add(self.rule_class_name, "not valid")
    else
      true  
    end
  end

  def publish
    { "rule_class_name" => rule_class_name, 
      "title" => title, 
      "summary" => summary,
      "data" => data
    }
  end  

  def revert!(rule_data)
    self.rule_class_name = rule_data["rule_class_name"]
    self.title = rule_data["title"]
    self.summary = rule_data["summary"]
    self.data = rule_data["data"]
    
    self
  end  
  
  def rule
    return @rule unless @rule.nil?
    rule_class = RulesEngine::Discovery.rule_class(self.rule_class_name)
    return nil if rule_class.nil?
    @rule = rule_class.new
    @rule.data = self.data
    @rule
  end
  
  def rule_attributes=params
    raise 'rule class not found' if rule.nil?    
    rule.attributes = params
  end

  def rule_error
    return "class #{rule_class_name} missing" if rule.nil?
    return "#{rule.errors.values.join(', ')}" unless rule.valid?

    nil
  end
  
  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "re_workflow_id", "created_at", "updated_at"]
    end

end
