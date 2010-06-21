module RulesEngine  
  class Job
    
    @@max_rules = 500
    attr_reader :re_job, :re_pipeline, :re_rule
  
    def initialize(re_job)
      @re_job = re_job
    end
    
    def self.create()
      re_job = ReJob.create(:job_status => ReJob::JOB_STATUS_NONE)
      RulesEngine::Job.new(re_job)
    end
    
    def self.open(job_id)      
      re_job = ReJob.find_by_id(job_id) || ReJob.create(:job_status => ReJob::JOB_STATUS_NONE)
      re_job.update_attributes(:job_status => ReJob::JOB_STATUS_NONE)
      
      RulesEngine::Job.new(re_job)
    end      
    
    def run(pipeline_code, data = {})
      if @re_job.nil?
        audit("Job missing", ReJobAudit::AUDIT_FAILURE)
        return false
      end
      
      rule_count = 0
      done = false
      error = false
            
      @re_job.update_attributes(:job_status => ReJob::JOB_STATUS_RUNNING)  
      
      while (!done && rule_count < @@max_rules)
        rule_count += 1 
        
        activated_pipeline = RePipelineActivated.find_by_code(pipeline_code)
        unless activated_pipeline
          audit("Activated Pipleine : #{pipeline_code} not found", ReJobAudit::AUDIT_FAILURE) 
          error = done = true 
          next
        end  
        
        
        if activated_pipeline.re_rules.empty?
          audit("Pipleine : #{pipeline_code} has no rules", ReJobAudit::AUDIT_FAILURE) 
          error = done = true 
          next
        end

        @re_pipeline = activated_pipeline.re_pipeline
        audit("Pipleine : #{pipeline_code} started", ReJobAudit::AUDIT_SUCCESS)
        
        activated_pipeline.re_rules.each do | re_rule |
          rule = re_rule.rule
          unless rule
            audit("Rule : #{re_rule.rule_class_name} not found", ReJobAudit::AUDIT_FAILURE) 
            error = done = true 
            break 
          end  
        
          @re_rule = re_rule
          audit("Rule : #{re_rule.title} starting")                    
          rule_outcome = rule.process(self, data)
          audit("Rule : #{re_rule.title} finished")
          @re_rule = nil
          
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
            audit("Pipeline : #{pipeline_code} stop success", ReJobAudit::AUDIT_SUCCESS)
            done = true 
            break
          end
        
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
            audit("Pipeline : #{pipeline_code} stop failure", ReJobAudit::AUDIT_FAILURE)
            error = done = true 
            break
          end
        
          if !rule_outcome.nil? && rule_outcome.outcome == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
            audit("Pipeline : #{pipeline_code} start pipeline #{rule_outcome.pipeline_code}", ReJobAudit::AUDIT_SUCCESS)
            pipeline_code = rule_outcome.pipeline_code
            break
          end
          
          if activated_pipeline.re_rules[-1] == re_rule
            audit("Pipeline : #{pipeline_code} complete", ReJobAudit::AUDIT_SUCCESS)
            done = true 
            break
          end                  
        end
        
        @re_pipeline = nil
      end  

      if rule_count >= @@max_rules
        audit("Maximum pipeline depth #{@@max_rules} exceeded", ReJob::JOB_STATUS_FAILURE)
        error = true
      end
      
      @re_job.update_attributes(:job_status => error ? ReJob::JOB_STATUS_FAILURE : ReJob::JOB_STATUS_SUCCESS)
      
      !error
    end

    def audit(message, code=ReJobAudit::AUDIT_INFO)
        ReJobAudit.create({
          :re_job_id => re_job ? re_job.id : nil,
          :re_pipeline_id => re_pipeline ? re_pipeline.id : nil, 
          :re_rule_id => re_rule ? re_rule.id : nil,
          :audit_date => Time.now,  
          :audit_code => code,
          :audit_message => message});
      
      # puts "#{'*' * 5} #{re_job ? re_job.id : nil}, #{re_pipeline ? re_pipeline.id : nil}, #{re_rule ? re_rule.id : nil}, #{code}, #{message}"
    end
        
  end
end
