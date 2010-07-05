module RulesEngine  
  module Job
    
    JOB_STATUS_NONE = 0
    JOB_STATUS_RUNNING = 1
    JOB_STATUS_SUCCESS = 2
    JOB_STATUS_FAILURE = 3    
  
    autoload :DbJobRunner, 'rules_engine/job/runner/db_job_runner'
    # autoload :FileJobRunner, 'rules_engine/job/runner/file_job_runner'
    
    class << self
      def runner=(runner_options)
        type, *parameters = *([ runner_options ].flatten)

        case type
        when Symbol
          runner_class_name = type.to_s.camelize
          runner_class = RulesEngine::Job.const_get(runner_class_name)
          @runner = runner_class.new(*parameters)
        when nil
          @runner = nil
        else
          @runner = runner_options
        end
      end

      def runner
        throw "RulesEngine::Job::Runner required" unless @runner
        @runner 
      end      
    end
    
    class Runner      
      
      @@max_rules = 500
      
      def create
        throw "RulesEngine::Job::Runner required"
        # 0
      end
      
      def run(job_id, map, data = {})
        
        rule_count = 0
        done = false
        error = false
        
        pipeline_code = map['start_pipeline_code']
            
        while (!done && rule_count < @@max_rules)
          rule_count += 1 
        
          RulesEngine::job.auditor.audit(job_id, "Pipleine : #{pipeline_code} started", RulesEngine::Audit::AUDIT_SUCCESS)
          
          map["pipeline_#{pipeline_code}"].each do | pipeline_rule |
            rule_class = RulesEngine::Discovery.re_rule.rule_class(pipeline_rule["class_name"])
            unless rule_class
              RulesEngine::job.auditor.audit(job_id, "Rule : #{re_rule.rule_class_name} not found", RulesEngine::Audit::AUDIT_FAILURE) 
              error = done = true 
              break 
            end  
            rule = rule_class.new
            rule.data = pipeline_rule["data"]
            
            RulesEngine::job.auditor.audit(job_id, "Rule : #{re_rule.title} starting")                    
            rule_outcome = rule.process(data)
            RulesEngine::job.auditor.audit(job_id, "Rule : #{re_rule.title} finished")
          
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
              RulesEngine::job.auditor.audit(job_id, "Pipeline : #{pipeline_code} stop success", RulesEngine::Audit::AUDIT_SUCCESS)
              done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
              RulesEngine::job.auditor.audit(job_id, "Pipeline : #{pipeline_code} stop failure", RulesEngine::Audit::AUDIT_FAILURE)
              error = done = true 
              break
            end
        
            if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
              RulesEngine::job.auditor.audit(job_id, "Pipeline : #{pipeline_code} start pipeline #{rule_outcome.pipeline_code}", RulesEngine::Audit::AUDIT_SUCCESS)
              pipeline_code = rule_outcome.pipeline_code
              break
            end
          
            # last rule ine the pipeline
            if map["pipeline_#{pipeline_code}"][-1] == pipeline_rule
              RulesEngine::job.auditor.audit(job_id, "Pipeline : #{pipeline_code} complete", RulesEngine::Audit::AUDIT_SUCCESS)
              done = true 
              break
            end                  
          end          
        end  

        if rule_count >= @@max_rules
          RulesEngine::job.auditor.audit(job_id, "Maximum pipeline depth #{@@max_rules} exceeded", RulesEngine::Job::JOB_STATUS_FAILURE)
          error = true
        end
      
        !error
      end
      
      def status(job_id)
        throw "RulesEngine::Job::Runner required"
        # RulesEngine::Job::JOB_STATUS_NONE
      end      
      
      def history(page = 1, page_size = 20)
        throw "RulesEngine::Job::Runner required"
        # {:page => page, 
        #    :page_size => page_size,
        #    :next_page => nil, 
        #    :previous_page => nil,
        #    :jobs => [
        #               {:job_id => '1234', 
        #                 :status => RulesEngine::Job::JOB_STATUS_RUNNING, 
        #                 :started => Time.now.utc.to_s, 
        #                 :finished => Time.now.utc.to_s, 
        #               }
        #             ]
        # }.to_json
      end
    end  
  end
end
