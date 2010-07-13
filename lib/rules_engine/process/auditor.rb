module RulesEngine  
  module Process
    
    AUDIT_NONE    =   -1
    AUDIT_INFO    =   0
    AUDIT_SUCCESS =   1
    AUDIT_FAILURE =   2

    autoload :DbAuditor, 'rules_engine/process/auditor/db_auditor'
    
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

      def audit(process_id, message, code = RulesEngine::Process::AUDIT_INFO)
        if perform_audit?(code)
          if defined?(Rails) && Rails.logger 
            case code
            when RulesEngine::Process::AUDIT_INFO, RulesEngine::Process::AUDIT_SUCCESS
              Rails.logger.info("#{'*' * 5} #{process_id}, #{code}, #{message}")
            when RulesEngine::Process::AUDIT_FAILURE
              Rails.logger.error("#{'*' * 5} #{process_id}, #{code}, #{message}")
            end
          else  
            $stderr.puts("#{'*' * 5} #{process_id}, #{code}, #{message}")
          end
        end   
      end
    
      def history(process_id)
        []
      end
    
      def perform_audit?(code)
        audit_level.nil? || (audit_level != RulesEngine::Process::AUDIT_NONE && code >= audit_level)
      end
    end  
  end
end
