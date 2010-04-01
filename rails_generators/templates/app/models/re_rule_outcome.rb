class ReRuleOutcome < ActiveRecord::Base
  belongs_to :re_rule

  validates_associated  :re_rule
  validates_presence_of :outcome  
  def validate    
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE && pipeline_code.blank?
      errors.add(:pipeline_code, "pipeline code required")
    end
  end

  def copy! re_rule_outcome    
    self.outcome = re_rule_outcome.outcome
    self.pipeline_code = re_rule_outcome.pipeline_code
    self
  end

  def equals? re_rule_outcome    
    if outcome != re_rule_outcome.outcome
      return false
    end
      
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
      return false unless pipeline_code == re_rule_outcome.pipeline_code
      #TODO check the pipeline equals the pipeline code
    end  
    
    return true    
  end

  def verify
    if outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
      return "pipeline code required" if pipeline_code.blank?
      return "outcome pipeline missing" unless RePipeline.find(:first, :conditions => ["code = ?", pipeline_code])
    end
    
    return nil
  end
  
end
