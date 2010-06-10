module RulesEngine  
  class Rule
    class_inheritable_accessor :options
    @@options = {}

    def self.inherited(base)
      base.extend(ClassMethods) 
    end

    module ClassMethods  
      def rule_class_name
        self.name.classify
      end
    end
            
    ##################################################################
    def title
      return nil
    end
    
    def summary
      return nil
    end
    
    def data
      return nil
    end
    
    def data= data
      return nil
    end

    def expected_outcomes
      return [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT, :pipeline_code => nil]
    end
    
    ##################################################################
    def attributes=(params)
    end

    ##################################################################
    def valid?
      true
    end

    def errors
      @errors ||= {}
      return @errors
    end    

    ##################################################################
    def after_create(rule_id)
    end
    
    def before_destroy(rule_id)
    end
    
    ##################################################################
    # return an RulesEngine::RuleOutcome object to define what to do next
    # or nil to continue to the next rule
    def process(job_id, data)
      rule_outcome = RulesEngine::RuleOutcome.new
      
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_NEXT
      # rule_outcome.pipeline_code = 
      
      rule_outcome
    end  
    
  end
end
