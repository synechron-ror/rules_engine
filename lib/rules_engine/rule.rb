module RulesEngine  
  class Rule
    class_inheritable_accessor :options
    @@options = {}

    def self.inherited(base)
      base.extend(ClassMethods) 
    end

    module ClassMethods  
      def rule_class
        self.to_s
      end
    end
      
    ##################################################################
    def attributes=(params)
    end
    
    def valid?
      true
    end

    def errors
      @errors ||= []
      return @errors
    end

    def load(re_rule)
      true
    end

    def save(re_rule)
      re_rule.rule_class = self.class.rule_class
      true
    end    
    
    def after_create(re_rule)
    end
    
    def after_update(re_rule)
    end
    
    def before_destroy(re_rule)
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
