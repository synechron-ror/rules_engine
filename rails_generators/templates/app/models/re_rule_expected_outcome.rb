class ReRuleExpectedOutcome < ActiveRecord::Base
  belongs_to :re_rule

  validates_associated  :re_rule
  validates_presence_of :outcome  

  def validate    
    if outcome == RulesEngine::Rule::Outcome::START_WORKFLOW && workflow_code.blank?
      errors.add(:workflow_code, "workflow code required")
    end
  end
end
