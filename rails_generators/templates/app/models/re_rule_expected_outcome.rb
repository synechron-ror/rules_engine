class ReRuleExpectedOutcome < ActiveRecord::Base
  belongs_to :re_rule

  validates_associated  :re_rule
  validates_presence_of :outcome  

  def validate    
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW && workflow_code.blank?
      errors.add(:workflow_code, "workflow code required")
    end
  end

  # def copy! re_rule_expected_outcome    
  #   self.outcome = re_rule_expected_outcome.outcome
  #   self.workflow_code = re_rule_expected_outcome.workflow_code
  #   self
  # end

end
