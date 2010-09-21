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
      class << self    # C's singleton class
       attr_accessor :options
      end      
      
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
      def before_create()
      end
    
      def before_update()
      end
      
      def before_destroy()
      end
    
      ##################################################################
      # execute the rule
      # return an RulesEngine::Rule::Outcome object to define what to do next
      # if nil to continue to the next rule
      def process(process_id, plan, data)
        # process.audit("process #{title}", RulesEngine::Process::AUDIT_INFO)                        
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, 'next_workflow')
        RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
      end      
    end
  end  
end
