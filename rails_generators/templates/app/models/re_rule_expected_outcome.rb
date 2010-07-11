class ReRuleExpectedOutcome < ActiveRecord::Base
  belongs_to :re_rule

  validates_associated  :re_rule
  validates_presence_of :outcome  

  def validate    
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW && workflow_code.blank?
      errors.add(:workflow_code, "workflow code required")
    end
  end

  def copy! re_rule_expected_outcome    
    self.outcome = re_rule_expected_outcome.outcome
    self.workflow_code = re_rule_expected_outcome.workflow_code
    self
  end

  def equals? re_rule_expected_outcome    
    if outcome != re_rule_expected_outcome.outcome
      return false
    end
      
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW
      return false unless workflow_code == re_rule_expected_outcome.workflow_code
      #TODO check the workflow equals the workflow code
    end  
    
    return true    
  end
end
