module RulesEngine
  module Rule
    class Simple < RulesEngine::Rule::Definition

      attr_reader :description
      ##################################################################
      # class options
      self.options = 
        {
          :group => 'General',
          :display_name => 'Simple',    
          :help_partial => '/re_rule_definitions/<%=rule_name%>/help',
          :new_partial => '/re_rule_definitions/<%=rule_name%>/new',
          :edit_partial => '/re_rule_definitions/<%=rule_name%>/edit'
        } 
  
      ##################################################################
      # set the rule data
      def data= data
        if data.nil?
          @title = nil
          @description = nil
        else
          @title, @description = ActiveSupport::JSON.decode(data)
        end  
      end
  
      ##################################################################
      # get the rule attributes
      def title
        @title
      end
  
      def summary
        description || "Does Nothing"
      end
  
      def data
        [title, description].to_json
      end
  
      def expected_outcomes
        [:outcome => RulesEngine::Rule::Outcome::NEXT]
      end
  
      ##################################################################
      # set the rule attributes
      def attributes=(params)
        param_hash = params.symbolize_keys

        @title = param_hash[:<%=rule_name%>_title]
        @description = param_hash[:<%=rule_name%>_description]
      end
  
      ##################################################################
      # validation and errors
      def valid?
        @errors = {}
        @errors[:<%=rule_name%>_title] = "Title required" if title.blank?    
        return @errors.empty?
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
      # this rule does nothing
      def process(process_id, data)
        RulesEngine::Process.auditor.audit(process_id, "Inside Rule #{title}", RulesEngine::Process::AUDIT_INFO)                        
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE)
        # RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, 'next_workflow')
        RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
      end  
    end
  end
end  