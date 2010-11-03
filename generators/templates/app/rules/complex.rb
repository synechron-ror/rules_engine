module RulesEngine
  module Rule
    class <%=rule_name.camelize%> < RulesEngine::Rule::Definition

      attr_reader :match_words
      attr_reader :match_type
      attr_reader :workflow_action
      attr_reader :workflow_code

      MESSAGE_MATCH_ALL         = 0 unless defined? MESSAGE_MATCH_ALL
      MESSAGE_MATCH_WORD        = 1 unless defined? MESSAGE_MATCH_WORD
      MESSAGE_MATCH_BEGIN_WITH  = 2 unless defined? MESSAGE_MATCH_BEGIN_WITH
      MESSAGE_MATCH_END_WITH    = 3 unless defined? MESSAGE_MATCH_END_WITH
      
      ##################################################################
      # class options
      self.options = 
        {
          :group => 'General',
          :display_name => '<%=rule_name.camelize%>',    
          :help_partial => '/re_rules/<%=rule_name%>/help',
          :new_partial => '/re_rules/<%=rule_name%>/new',
          :edit_partial => '/re_rules/<%=rule_name%>/edit'
        } 
  
      ##################################################################
      # set the rule data
      def data= data
        if data.nil?
          @title = nil
          @match_words = nil
          @match_type = RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_ALL
          @workflow_action = 'next'
          @workflow_code = nil
        else
          @title, @match_words, tmp_match_type, @workflow_action, @workflow_code = ActiveSupport::JSON.decode(data)
          @match_type = tmp_match_type.to_i
        end  
      end
  
      ##################################################################
      # get the rule attributes
      def title
        @title
      end

      def summary
        "The next action is based on a match being found"
      end
  
      def data
        [title, match_words, match_type.to_s, workflow_action, workflow_code].to_json
      end
  
      def expected_outcomes
        case workflow_action    
        when 'next'
          [:outcome => RulesEngine::Rule::Outcome::NEXT]
        when 'stop_success'
          [:outcome => RulesEngine::Rule::Outcome::STOP_SUCCESS]
        when 'stop_failure'
          [:outcome => RulesEngine::Rule::Outcome::STOP_FAILURE]
        when 'start_workflow'
          [:outcome => RulesEngine::Rule::Outcome::START_WORKFLOW, :title => "Start Workflow : #{workflow_code}"]
        else
          [:outcome => RulesEngine::Rule::Outcome::NEXT]  
        end
      end
  
      ##################################################################
      # set the rule attributes
      def attributes=(params)
        param_hash = params.symbolize_keys

        @title = param_hash[:<%=rule_name%>_title]
    
        @match_words = []
        return if param_hash[:<%=rule_name%>_match_words].nil?
        param_hash[:<%=rule_name%>_match_words].each do |key, values| 
          if values.is_a?(Hash)
            word_hash = values.symbolize_keys
            @match_words << word_hash[:word].downcase unless word_hash[:word].blank? || word_hash[:_delete] == '1'
          end  
        end
    
        @match_type = param_hash[:<%=rule_name%>_match_type].to_i
    
        @workflow_action = param_hash[:<%=rule_name%>_workflow_action] || 'next'
        @workflow_code = param_hash[:<%=rule_name%>_workflow_code]
      end
  
      ##################################################################
      # validation and errors
      def valid?
        @errors = {}
        @errors[:<%=rule_name%>_title] = "Title required" if title.blank?    
        @errors[:<%=rule_name%>_match_words] = "At least one word must be defined" if match_words.nil? || match_words.empty?
        @errors[:<%=rule_name%>_workflow_code] = "Workflow code required" if workflow_action == 'start_workflow' && workflow_code.blank?
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
      # if a match is found procees to the expected outcome
      # it gets the data parameter :message
      # it sets the data parameter :match
      def process(process_id, plan, data)
        message = data[:message] || data["message"]    
        data[:matches] = []
        data[:misses] = []
        
        match_words.each do |match_word|
          filter = case match_type
          when RulesEngine::Rule::MessageFilter::MESSAGE_MATCH_ALL
            /^#{match_word}$/i
          when RulesEngine::Rule::MessageFilter::MESSAGE_MATCH_WORD
            /\b#{match_word}\b/i
          when RulesEngine::Rule::MessageFilter::MESSAGE_MATCH_BEGIN_WITH
            /^#{match_word}/i
          when RulesEngine::Rule::MessageFilter::MESSAGE_MATCH_END_WITH
            /#{match_word}$/i
          end
          
          if filter =~ message
            RulesEngine::Process.auditor.audit(process_id, "found #{match_word}", RulesEngine::Process::AUDIT_INFO)
            data[:matches] << match_word
          else
            RulesEngine::Process.auditor.audit(process_id, "missed #{match_word}", RulesEngine::Process::AUDIT_INFO)
            data[:misses] << match_word
          end
        end
        
        unless data[:matches].empty?
          case workflow_action
          when 'stop_success'
            return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS)
          when 'stop_failure'
            return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE)
          when 'start_workflow'
            return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, workflow_code)
          else #'next'
            return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
          end
        end
        
        RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
      end  
    end
  end  
end