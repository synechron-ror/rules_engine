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
      
      def run_plan(process_id, plan, data = {})
        RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : started", RulesEngine::Process::AUDIT_INFO)

        success = _run_plan_workflow(process_id, plan, plan["workflow"], data)

        if success
          RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : success", RulesEngine::Process::AUDIT_SUCCESS)
        else
          RulesEngine::Process.auditor.audit(process_id, "Plan : #{plan["code"]} : failure", RulesEngine::Process::AUDIT_FAILURE)
        end
          
        success    
      end
      
      def run_workflow(process_id, plan, workflow_name, data = {})        
        RulesEngine::Process.auditor.audit(process_id, "Workflow : #{workflow_name} : started", RulesEngine::Process::AUDIT_INFO)

        success = _run_plan_workflow(process_id, plan, workflow_name, data)

        if success
          RulesEngine::Process.auditor.audit(process_id, "Workflow : #{workflow_name} : success", RulesEngine::Process::AUDIT_SUCCESS)
        else
          RulesEngine::Process.auditor.audit(process_id, "Workflow : #{workflow_name} : failure", RulesEngine::Process::AUDIT_FAILURE)
        end
          
        success    
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
      
      protected
        def _run_plan_workflow(process_id, plan, workflow_name, data = {})
        
          workflow_count = 0
          while (workflow_count < @@max_workflows)
            workflow_count += 1 
            
            workflow = plan["workflow_#{workflow_name}"]
            if workflow.nil?
              RulesEngine::Process.auditor.audit(process_id, "Workflow : #{workflow_name} : not found", RulesEngine::Process::AUDIT_FAILURE) 
              return false;
            end
            
            rule_outcome = _run_workflow_rules(process_id, plan, workflow, data)
            
            if rule_outcome.nil?
              return true
            elsif rule_outcome.outcome == RulesEngine::Rule::Outcome::STOP_SUCCESS
              return true
            elsif rule_outcome.outcome == RulesEngine::Rule::Outcome::STOP_FAILURE
              return false
            elsif rule_outcome.outcome == RulesEngine::Rule::Outcome::START_WORKFLOW
              workflow_name = rule_outcome.workflow_code
            else # rule_outcome.outcome == RulesEngine::Rule::Outcome::NEXT
              return true              
            end
          end  

          RulesEngine::Process.auditor.audit(process_id, "Maximum workflow depth #{@@max_workflows} exceeded", RulesEngine::Process::PROCESS_STATUS_FAILURE)
          return false
        end
        
        def _run_workflow_rules(process_id, plan, workflow, data = {})
          
          RulesEngine::Process.auditor.audit(process_id, "Rules For : #{workflow["code"]} : started", RulesEngine::Process::AUDIT_INFO)
          
          workflow["rules"].each do | workflow_rule |
            rule_class = RulesEngine::Discovery.rule_class(workflow_rule["rule_class_name"])
            unless rule_class
              RulesEngine::Process.auditor.audit(process_id, "Rule : #{workflow_rule["rule_class_name"]} : not found", RulesEngine::Process::AUDIT_FAILURE) 
              return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE)
            end  
            
            rule = rule_class.new
            rule.data = workflow_rule["data"]
          
            RulesEngine::Process.auditor.audit(process_id, "Rule : #{rule.title} : starting")                    
            rule_outcome = rule.process(process_id, plan, data)
            RulesEngine::Process.auditor.audit(process_id, "Rule : #{rule.title} : finished")

            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::Rule::Outcome::STOP_SUCCESS
              RulesEngine::Process.auditor.audit(process_id, "Rules For : #{workflow["code"]} : stop success", RulesEngine::Process::AUDIT_SUCCESS)
              return rule_outcome
            end
      
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::Rule::Outcome::STOP_FAILURE
              RulesEngine::Process.auditor.audit(process_id, "Rules For : #{workflow["code"]} : stop failure", RulesEngine::Process::AUDIT_FAILURE)
              return rule_outcome
            end
      
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::Rule::Outcome::START_WORKFLOW
              RulesEngine::Process.auditor.audit(process_id, "Rules For  : #{workflow["code"]} : start next workflow - #{rule_outcome.workflow_code}", RulesEngine::Process::AUDIT_INFO)
              return rule_outcome
            end
          end
          
          RulesEngine::Process.auditor.audit(process_id, "Rules For : #{workflow["code"]} : stop success", RulesEngine::Process::AUDIT_SUCCESS)
          return RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS)
        end
    end  
  end
end
