module RulesEngine  
  module Rule
    class Outcome
    
      def initialize(outcome, workflow_code = nil)
        @outcome = outcome
        @workflow_code = workflow_code
      end

      NEXT  =            0
      STOP_SUCCESS  =    1
      STOP_FAILURE  =    2
      START_WORKFLOW  =  3

      attr_accessor :outcome
      attr_accessor :workflow_code    
    end
  end  
end