module RulesEngine  
  module Process
    
    PROCESS_STATUS_NONE = 0
    PROCESS_STATUS_RUNNING = 1
    PROCESS_STATUS_SUCCESS = 2
    PROCESS_STATUS_FAILURE = 3    
  
    autoload :DbRunner, 'rules_engine/process/runner/db_runner'
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
      
      @@max_workflows = 500
      
      def create
        throw "RulesEngine::Process::Runner required"
        # 0
      end
      
      def run(process_id, plan, data = {})
        
        RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : started", RulesEngine::Process::AUDIT_INFO)

        workflow_count = 0
        done = false
        error = false
        
        first_workflow = plan['first_workflow']
        last_workflow = plan['last_workflow']
        
        current_workflow = first_workflow
        next_workflow = ""
        while (!done && workflow_count < @@max_workflows)
          workflow_count += 1 
        
          RulesEngine::Process.auditor.audit(process_id, "Workflow : #{current_workflow} : started", RulesEngine::Process::AUDIT_INFO)
          
          workflow = plan["workflow_#{current_workflow}"]
          if workflow.nil?
            RulesEngine::Process.auditor.audit(process_id, "Workflow : #{current_workflow} : not found", RulesEngine::Process::AUDIT_FAILURE) 
            error = done = true 
            break 
          end
          
          workflow["rules"].each do | workflow_rule |
            rule_class = RulesEngine::Discovery.rule_class(workflow_rule["rule_class_name"])
            unless rule_class
              RulesEngine::Process.auditor.audit(process_id, "Rule : #{workflow_rule["rule_class_name"]} : not found", RulesEngine::Process::AUDIT_FAILURE) 
              error = done = true 
              break 
            end  
            rule = rule_class.new
            rule.data = workflow_rule["data"]
            
            RulesEngine::Process.auditor.audit(process_id, "Rule : #{rule.title} : starting")                    
            rule_outcome = rule.process(process_id, data)
            RulesEngine::Process.auditor.audit(process_id, "Rule : #{rule.title} : finished")

            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
              RulesEngine::Process.auditor.audit(process_id, "Workflow : #{current_workflow} : stop success", RulesEngine::Process::AUDIT_SUCCESS)
              done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
              RulesEngine::Process.auditor.audit(process_id, "Workflow : #{current_workflow} : stop failure", RulesEngine::Process::AUDIT_FAILURE)
              error = done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW
              RulesEngine::Process.auditor.audit(process_id, "Workflow : #{current_workflow} : start next workflow - #{rule_outcome.workflow_code}", RulesEngine::Process::AUDIT_INFO)
              next_workflow = rule_outcome.workflow_code
              break
            end
          end          
          
          if next_workflow.blank?
            current_workflow = workflow["next_workflow"]
          else
            current_workflow = next_workflow  
          end            
          
          if current_workflow.blank?
            done = true 
            break
          end
        end  

        if workflow_count >= @@max_workflows
          RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : error - Maximum workflow depth #{@@max_workflows} exceeded", RulesEngine::Process::PROCESS_STATUS_FAILURE)
          error = true
        end

        RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : complete", RulesEngine::Process::AUDIT_INFO)
      
        !error
      end
      
      def status(process_id)
        throw "RulesEngine::Process::Runner required"
      end      
      
      def history(plan_code = nil, options = {})
        throw "RulesEngine::Process::Runner required"
        # {
        #   :proceses => []
        # }
      end
    end  
  end
end
