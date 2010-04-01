module RulesEngine  
  class JobRunner
    
    @@max_rules = 500
    
    def self.create_job()
      ReJob.create(:job_status => ReJob::JOB_STATUS_NONE).id
    end
    
    def self.run_pipleine(re_job_id, pipeline_code, data = {})
      rule_count = 0
      done = false
      error = false      
      
      re_job = ReJob.find_by_id(re_job_id)
      re_job.update_attributes(:job_status => ReJob::JOB_STATUS_RUNNING) unless re_job.nil?
      
      while (!done && rule_count < @@max_rules)
        rule_count += 1 
        
        activated_pipeline = RePipelineActivated.find_by_code(pipeline_code)
        unless activated_pipeline
          audit_pipeline(re_job_id, nil, ReJobAudit::AUDIT_PIPELINE_END, false, "Pipleine #{pipeline_code} not found") 
          error = done = true 
          next
        end  
        re_pipeline_id = activated_pipeline.re_pipeline.id
        
        audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_START, true, "Pipleine #{pipeline_code} started") 
        
        activated_pipeline.re_rules.each do | re_rule |
          rule_class = RulesEngine::Discovery.rule_class(re_rule.rule_class)
          unless rule_class
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, false, "Rule #{re_rule.rule_class} not found") 
            error = done = true 
            break 
          end  
        
          rule = rule_class.new
          unless rule.load(re_rule)
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, false, "Rule #{re_rule.rule_class} cannot load")
            error = done = true 
            break 
          end  
        
          audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_INFO, true, "Rule #{re_rule.title} starting")
          rule_outcome = rule.process(re_job_id, data)
          audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_INFO, true, "Rule #{re_rule.title} finished")
        
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, true, "Pipeline #{pipeline_code} complete")
            done = true 
            break
          end
        
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, false, "Pipeline #{pipeline_code} complete")
            error = done = true 
            break
          end
        
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, true, "Pipeline #{pipeline_code} complete")
            pipeline_code = rule_outcome.pipeline_code
            break
          end
          
          if activated_pipeline.re_rules[-1] == re_rule
            audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, true, "Pipeline #{pipeline_code} complete")
            done = true 
            break
          end
        end
      end  

      if rule_count >= @@max_rules
        audit_pipeline(re_job_id, re_pipeline_id, ReJobAudit::AUDIT_PIPELINE_END, false, "Maximum pipeline depth #{@@max_rules} exceeded")
        error = true
      end
      
      re_job.update_attributes(:job_status => error ? ReJob::JOB_STATUS_FAILED : ReJob::JOB_STATUS_SUCCESS) unless re_job.nil?
      
      error
    end

    def self.audit_pipeline(re_job_id, re_pipeline_id, code, success, message)
      ReJobAudit.create({
        :re_job_id => re_job_id,
        :re_pipeline_id => re_pipeline_id, 
        :re_rule_id => nil,
        :audit_date => Time.now,  
        :audit_code => code,
        :audit_success => success, 
        :audit_data => message
      });
      
      puts "#{'*' * 5} #{re_job_id}, #{re_pipeline_id}, #{code} #{success}, #{message}"
    end

    def self.audit_rule(re_job_id, re_pipeline_id, re_rule_id, code, success, message)
      ReJobAudit.create({
        :re_job_id => re_job_id,
        :re_pipeline_id => re_pipeline_id, 
        :re_rule_id => re_rule_id,
        :audit_date => Time.now,  
        :audit_code => code,
        :audit_success => success, 
        :audit_data => message
      });

      puts "#{'*' * 10} #{re_job_id}, #{re_pipeline_id}, #{re_rule_id}, #{rule_title}, #{success}, #{message}"
    end
        
  end
end
