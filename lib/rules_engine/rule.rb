module RulesEngine  
  class Rule
    def self.inherited(base)
      base.extend(ClassMethods) 
    end

    module ClassMethods  
      def rule_class_name
        self.name.classify
      end
    end

    ##################################################################
    # class options
    class_inheritable_accessor :options
    @@options = {
      # :group          => "The group the rule belongs to",
      # :display_name   => "name to use on forms and views",
      # :help_partial   => "the help html.erb template",
      # :new_partial    => "the new html.erb template",
      # :edit_partial   => "the edit html.erb template"
    }

    ##################################################################
    # set the rule data
    def data= data      
    end

    ##################################################################
    # get the rule attributes
    def title
      return nil
    end
    
    def summary
      return nil
    end
    
    def data
      return nil
    end
    
    def expected_outcomes
      return [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT, :pipeline_code => nil]
    end
    
    ##################################################################
    # set the rule attributes
    def attributes=(params)
    end

    ##################################################################
    # validation and errors
    def valid?
      true
    end

    def errors
      @errors ||= {}
      return @errors
    end    

    ##################################################################
    # callbacks when the rule is added and removed from a pipeline
    def after_add_to_pipeline(re_pipeline_id, re_rule_id)
    end
    
    def before_remove_from_pipeline(re_pipeline_id, re_rule_id)
    end
    
    ##################################################################
    # execute the rule
    # return an RulesEngine::RuleOutcome object to define what to do next
    # if nil to continue to the next rule
    def process(job_id, data)
      rule_outcome = RulesEngine::RuleOutcome.new
      
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_NEXT
      # rule_outcome.pipeline_code = 
      
      rule_outcome
    end  
    
  end
end
