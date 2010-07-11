module RulesEngine
  module Process
    class ReProcessAudit < ActiveRecord::Base
  
      validates_presence_of :code
    
      named_scope :by_process_id, lambda {|process_id| {:conditions => ['process_id = ?', process_id]} }
      named_scope :order_id, lambda {|order| {:order => "id #{order}"} }
      named_scope :order_created_at, lambda {|order| {:order => "created_at #{order}"} }
    end

    class DbProcessAuditor < Auditor

      def initialize(*options)        
      end
      
      def audit(process_id, message, code = RulesEngine::Audit::AUDIT_INFO)
        if perform_audit?(code)
          ReProcessAudit.create({
            :process_id => process_id,
            :created_at => Time.now,  
            :code => code,
            :message => message});
        end  
      end
  
      def history(process_id)
        process_audits = ReProcessAudit.by_process_id(process_id).order_id('ASC').order_date('ASC').find(:all).map do |re_process_audit| 
                                  {:process_id => re_process_audit.process_id || '', 
                                    :created => re_process_audit.created_at.utc.to_s, 
                                    :code => re_process_audit.code, 
                                    :message => re_process_audit.message}
                                  end
                                  
        {:process_audits => process_audits}.to_json
      end    
    end  
  end  
end