module RulesEngine  
  module Job
    
    AUDIT_NONE    =   -1
    AUDIT_INFO    =   0
    AUDIT_SUCCESS =   1
    AUDIT_FAILURE =   2

    # autoload :DBAuditor, 'rules_engine/job/auditor/db_auditor'
    autoload :ReJobAuditor, 'rules_engine/job/auditor/re_job_auditor'
    
    class << self
      def perform_auditing?
        !@auditor.nil? 
      end

      def auditor=(auditor_options)
        type, *parameters = *([ auditor_options ].flatten)

        case type
        when Symbol
          auditor_class_name = type.to_s.camelize
          auditor_class = RulesEngine::Job.const_get(auditor_class_name)
          @auditor = auditor_class.new(*parameters)
        when nil
          @auditor = Auditor.new
        else
          @auditor = auditor_options
        end
      end

      def auditor
        @auditor ||= Auditor.new 
      end      
    end
    
    class Auditor
      attr_accessor :audit_level

      def audit(job_id, message, code = RulesEngine::Audit::AUDIT_INFO)
        if perform_audit?(code)
          logger.debug("#{'*' * 5} #{re_job_id}, #{re_pipeline_id}, #{re_rule_id}, #{code}, #{message}")
        end   
      end
    
      def history(job_id)
        {:job_audits => "[]"}.to_json
      end
    
      def perform_audit?(code)
        audit_level.nil? || (audit_level != RulesEngine::Audit::AUDIT_NONE && code >= audit_level)
      end
    end  
  end
end
