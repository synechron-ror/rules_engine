module RulesEngine  
  module Process
    
    PROCESS_STATUS_NONE = 0
    PROCESS_STATUS_RUNNING = 1
    PROCESS_STATUS_SUCCESS = 2
    PROCESS_STATUS_FAILURE = 3    
  
    autoload :DbProcessRunner, 'rules_engine/process/runner/db_process_runner'
    # autoload :FileProcessRunner, 'rules_engine/process/runner/file_process_runner'
    
    class << self
      def runner=(runner_options)
        type, *parameters = *([ runner_options ].flatten)

        case type
        when Symbol
          runner_class_name = type.to_s.camelize
          runner_class = RulesEngine::Process.const_get(runner_class_name)
          @runner = runner_class.new(*parameters)
        when nil
          @runner = nil
        else
          @runner = runner_options
        end
      end

      def runner
        throw "RulesEngine::Process::Runner required" unless @runner
        @runner 
      end      
    end
    
    class Runner      
      
      @@max_rules = 500
      
      def create
        throw "RulesEngine::Process::Runner required"
        # 0
      end
      
      def run(process_id, plan, data = {})
        
        rule_count = 0
        done = false
        error = false
        
        workflow_code = plan['start_workflow_code']
            
        while (!done && rule_count < @@max_rules)
          rule_count += 1 
        
          RulesEngine::process.auditor.audit(process_id, "Pipleine : #{workflow_code} started", RulesEngine::Audit::AUDIT_SUCCESS)
          
          plan["workflow_#{workflow_code}"].each do | workflow_rule |
            rule_class = RulesEngine::Discovery.re_rule.rule_class(workflow_rule["class_name"])
            unless rule_class
              RulesEngine::process.auditor.audit(process_id, "Rule : #{re_rule.rule_class_name} not found", RulesEngine::Audit::AUDIT_FAILURE) 
              error = done = true 
              break 
            end  
            rule = rule_class.new
            rule.data = workflow_rule["data"]
            
            RulesEngine::process.auditor.audit(process_id, "Rule : #{re_rule.title} starting")                    
            rule_outcome = rule.process(data)
            RulesEngine::process.auditor.audit(process_id, "Rule : #{re_rule.title} finished")
          
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
              RulesEngine::process.auditor.audit(process_id, "Workflow : #{workflow_code} stop success", RulesEngine::Audit::AUDIT_SUCCESS)
              done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
              RulesEngine::process.auditor.audit(process_id, "Workflow : #{workflow_code} stop failure", RulesEngine::Audit::AUDIT_FAILURE)
              error = done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW
              RulesEngine::process.auditor.audit(process_id, "Workflow : #{workflow_code} start workflow #{rule_outcome.workflow_code}", RulesEngine::Audit::AUDIT_SUCCESS)
              workflow_code = rule_outcome.workflow_code
              break
            end
          
            # last rule ine the workflow
            if plan["workflow_#{workflow_code}"][-1] == workflow_rule
              RulesEngine::process.auditor.audit(process_id, "Workflow : #{workflow_code} complete", RulesEngine::Audit::AUDIT_SUCCESS)
              done = true 
              break
            end                  
          end          
        end  

        if rule_count >= @@max_rules
          RulesEngine::process.auditor.audit(process_id, "Maximum workflow depth #{@@max_rules} exceeded", RulesEngine::Process::PROCESS_STATUS_FAILURE)
          error = true
        end
      
        !error
      end
      
      def status(process_id)
        throw "RulesEngine::Process::Runner required"
        # RulesEngine::Process::PROCESS_STATUS_NONE
      end      
      
      def history(page = 1, page_size = 20)
        throw "RulesEngine::Process::Runner required"
        # {:page => page, 
        #    :page_size => page_size,
        #    :next_page => nil, 
        #    :previous_page => nil,
        #    :processs => [
        #               {:process_id => '1234', 
        #                 :status => RulesEngine::Process::PROCESS_STATUS_RUNNING, 
        #                 :started => Time.now.utc.to_s, 
        #                 :finished => Time.now.utc.to_s, 
        #               }
        #             ]
        # }.to_json
      end
    end  
  end
end
