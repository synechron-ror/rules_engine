module RulesEngine
  module Rule
    class <%=rule_class%> < RulesEngine::Rule::Definition

      attr_reader :match_words
      attr_reader :workflow_action
      attr_reader :workflow_code

      ##################################################################
      # class options
      self.options = 
        {
          :group => 'General',
          :display_name => '<%=rule_class%>',    
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
          @workflow_action = 'next'
          @workflow_code = nil
        else
          @title, @match_words, @workflow_action, @workflow_code = ActiveSupport::JSON.decode(data)
        end  
      end
  
      ##################################################################
      # get the rule attributes
      def title
        @title
      end

      def summary
        "Match the #{match_words.size == 1 ? 'word' : 'words'} #{match_words.join(', ')}"
      end
  
      def data
        [title, match_words, workflow_action, workflow_code].to_json
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
      # it gets the data parameter :tweet
      # it sets the data parameter :match
      def process(process_id, plan, data)
        tweet = data[:tweet] || data["tweet"]    
        if tweet.blank?
          return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT) 
        end
    
        match_words.each do |word|
          if /\b#{word}\b/i =~ tweet        
            RulesEngine::Process.auditor.audit(process_id, "Found #{word}", RulesEngine::Process::AUDIT_INFO)
            data[:tweet_match] = word
        
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
        end
        
        RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT)
      end  
    end
  end  
end