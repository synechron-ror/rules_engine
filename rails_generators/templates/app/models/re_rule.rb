class ReRule < ActiveRecord::Base
  belongs_to :re_workflow
  has_many  :re_rule_expected_outcomes, :dependent => :destroy, :order => "outcome ASC"
  acts_as_list :scope => :re_workflow
      
  validates_associated  :re_workflow
  validates_presence_of :rule_class_name

  default_scope :order => 're_rules.position ASC'
  
  before_save :before_save_rule
  after_create :after_create_rule
  before_destroy :before_destroy_rule

  def before_save_rule
    return if rule.nil?
    self.title = rule.title
    self.summary = rule.summary
    self.data = rule.data
    
    self.re_rule_expected_outcomes = (rule.expected_outcomes || []).map { |expected_outcome| ReRuleExpectedOutcome.new(expected_outcome) }
    
    re_workflow.changed! if changes.detect { |change| !ignore_attributes.include?(change[0])}    
  end

  def after_create_rule
    rule.after_add_to_workflow(self.re_workflow.code) unless rule.nil?
  end

  def before_destroy_rule
    rule.before_remove_from_workflow(self.re_workflow.code) unless rule.nil?
  end

  def validate
    if self.rule.nil?
      errors.add("rule_class", "not found") 
    elsif !self.rule.valid?
      errors.add(self.rule_class_name, "not valid") 
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
    
    self.re_rule_expected_outcomes = (rule.expected_outcomes || []).map { |expected_outcome| ReRuleExpectedOutcome.new(expected_outcome) }
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

    re_rule_expected_outcomes.each do |re_rule_expected_outcome|
      next if re_rule_expected_outcome.workflow_code.blank?      

      re_workflow = ReWorkflow.find_by_code(re_rule_expected_outcome.workflow_code)
      return "#{re_rule_expected_outcome.workflow_code} missing" if re_workflow.nil?
      
      workflow_error = re_workflow.workflow_error
      return "#{re_rule_expected_outcome.workflow_code} invalid" unless re_workflow.workflow_error.blank?
    end
    
    nil
  end
  
  def re_rule_expected_outcome_next
    re_rule_expected_outcomes.detect{ |re_rule_expected_outcome| re_rule_expected_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_NEXT }
  end
  
  def re_rule_expected_outcome_success
    re_rule_expected_outcomes.detect{ |re_rule_expected_outcome| re_rule_expected_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS }
  end

  def re_rule_expected_outcome_failure
    re_rule_expected_outcomes.detect{ |re_rule_expected_outcome| re_rule_expected_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE }
  end

  def re_rule_expected_outcomes_start_workflow
    re_rule_expected_outcomes.select{ |re_rule_expected_outcome| re_rule_expected_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW }
  end

  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "re_workflow_id", "created_at", "updated_at"]
    end

end
