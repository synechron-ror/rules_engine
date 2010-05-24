class ReRule < ActiveRecord::Base
  belongs_to :re_pipeline
  acts_as_list :scope => :re_pipeline

  has_many  :re_rule_expected_outcomes, :dependent => :destroy, :order => "outcome ASC"
  has_many  :re_job_audits
    
  validates_associated  :re_pipeline
  validates_presence_of :title
  validates_presence_of :rule_class_name
  validates_presence_of :summary
  validates_presence_of :data_version
  validates_presence_of :data

  default_scope :order => 're_rules.position ASC'
  
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

  def verify
    return self.error unless self.error.blank?

    self.re_rule_expected_outcomes.each do |rule_expected_outcome|
      result = rule_expected_outcome.verify
      return result unless result.blank?
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
