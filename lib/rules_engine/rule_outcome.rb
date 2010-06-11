module RulesEngine  
  class RuleOutcome

    OUTCOME_NEXT  =            0
    OUTCOME_STOP_SUCCESS  =    1
    OUTCOME_STOP_FAILURE  =    2
    OUTCOME_START_PIPELINE  =  3

    attr_accessor :outcome
    attr_accessor :pipeline_code    
  end
end