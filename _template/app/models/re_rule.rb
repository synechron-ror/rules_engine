class ReRule < ActiveRecord::Base
  belongs_to :re_pipeline
  acts_as_list :scope => :re_pipeline

  has_many  :re_rule_expected_outcomes, :dependent => :destroy, :order => "outcome ASC"
  has_many  :re_job_audits
    
  validates_associated  :re_pipeline
  validates_presence_of :rule_class_name

  default_scope :order => 're_rules.position ASC'
  
  before_save :before_save_rule
  after_create :after_create_rule
  before_destroy :before_destroy_rule

  def validate
    if self.rule.nil?
      errors.add("rule_class", "not found") 
    elsif !self.rule.valid?
      errors.add(self.rule_class_name, "not valid") 
    end
  end
    
  def copy! re_rule
    activated_attrs = re_rule.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      self[key] = value
    end
    
    self.re_rule_expected_outcomes = re_rule.re_rule_expected_outcomes.map { |rule_expected_outcome| ReRuleExpectedOutcome.new.copy!(rule_expected_outcome) }
    
    self
  end

  def equals? re_rule
    activated_attrs = re_rule.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      return false unless self[key] == value
    end
    
    return false unless self.re_rule_expected_outcomes.length == re_rule.re_rule_expected_outcomes.length
    self.re_rule_expected_outcomes.each_with_index do |rule_expected_outcome, index|
      return false unless rule_expected_outcome.equals?(re_rule.re_rule_expected_outcomes[index])
    end
    
    true
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

  def before_save_rule
    raise 'rule class not found' if rule.nil?
    self.title = rule.title
    self.summary = rule.summary
    self.data = rule.data
    
    self.re_rule_expected_outcomes = (rule.expected_outcomes).map { |expected_outcome| ReRuleExpectedOutcome.new(expected_outcome) }
  end

  def after_create_rule
    # raise 'rule class not found' if rule.nil?
    rule.after_add_to_pipeline(self.re_pipeline_id, self.id)
  end

  def before_destroy_rule
    # raise 'rule class not found' if rule.nil?
    rule.before_remove_from_pipeline(self.re_pipeline_id, self.id)
  end

  def rule_error
    return "#{title} class #{rule_class_name} invalid" if rule.nil?
    return "#{title} invalid" unless rule.valid?

    re_rule_expected_outcomes.each do |re_rule_expected_outcome|
      next if re_rule_expected_outcome.pipeline_code.blank?      

      re_pipeline_activated = RePipelineActivated.find_by_code(re_rule_expected_outcome.pipeline_code)
      return "#{re_rule_expected_outcome.pipeline_code} not activated" if re_pipeline_activated.nil?
      
      pipeline_error = re_pipeline_activated.pipeline_error
      return "#{re_rule_expected_outcome.pipeline_code} invalid" unless re_pipeline_activated.pipeline_error.blank?
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

  def re_rule_expected_outcomes_start_pipeline
    re_rule_expected_outcomes.select{ |re_rule_expected_outcome| re_rule_expected_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE }
  end

  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "re_pipeline_id", "created_at", "updated_at"]
    end

end
