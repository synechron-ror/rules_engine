module RulesEngine  
  class RuleOutcome
    
    def initialize(outcome, workflow_code = nil)
      @outcome = outcome
      @workflow_code = workflow_code
    end

    OUTCOME_NEXT  =            0
    OUTCOME_STOP_SUCCESS  =    1
    OUTCOME_STOP_FAILURE  =    2
    OUTCOME_START_WORKFLOW  =  3

    attr_accessor :outcome
    attr_accessor :workflow_code    
  end
end