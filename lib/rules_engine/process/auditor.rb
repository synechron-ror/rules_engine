module RulesEngine  
  module Process
    
    AUDIT_NONE    =   -1
    AUDIT_INFO    =   0
    AUDIT_SUCCESS =   1
    AUDIT_FAILURE =   2

    # autoload :DBAuditor, 'rules_engine/process/auditor/db_auditor'
    autoload :DbProcessAuditor, 'rules_engine/process/auditor/db_process_auditor'
    
    class << self
      def perform_auditing?
        !@auditor.nil? 
      end

      def auditor=(auditor_options)
        type, *parameters = *([ auditor_options ].flatten)

        case type
        when Symbol
          auditor_class_name = type.to_s.camelize
          auditor_class = RulesEngine::Process.const_get(auditor_class_name)
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

      def audit(process_id, message, code = RulesEngine::Audit::AUDIT_INFO)
        if perform_audit?(code)
          logger.debug("#{'*' * 5} #{re_process_id}, #{re_workflow_id}, #{re_rule_id}, #{code}, #{message}")
        end   
      end
    
      def history(process_id)
        {:process_audits => "[]"}.to_json
      end
    
      def perform_audit?(code)
        audit_level.nil? || (audit_level != RulesEngine::Audit::AUDIT_NONE && code >= audit_level)
      end
    end  
  end
end
