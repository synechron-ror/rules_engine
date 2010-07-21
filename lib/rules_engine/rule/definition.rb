module RulesEngine  
  module Rule
    class Definition
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
        [:outcome => RulesEngine::Rule::Outcome::NEXT]
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
      # callbacks when the rule is added and removed from a workflow
      def after_add_to_workflow(workflow_code)
      end
    
      def before_remove_from_workflow(workflow_code)
      end
    
      ##################################################################
      # execute the rule
      # return an RulesEngine::Rule::Outcome object to define what to do next
      # if nil to continue to the next rule
      def process(process_id, data)
        # process.audit("process #{title}", RulesEngine::Process::AUDIT_INFO)                        
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, 'next_workflow')
        RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
      end      
    end
  end  
end