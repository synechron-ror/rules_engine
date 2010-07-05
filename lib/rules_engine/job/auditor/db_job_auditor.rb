module RulesEngine
  module Job
    class ReJobAudit < ActiveRecord::Base
  
      validates_presence_of :code
    
      named_scope :by_job_id, lambda {|job_id| {:conditions => ['job_id = ?', job_id]} }
      named_scope :order_id, lambda {|order| {:order => "id #{order}"} }
      named_scope :order_created_at, lambda {|order| {:order => "created_at #{order}"} }
    end

    class DbJobAuditor < Auditor

      def initialize(*options)        
      end
      
      def audit(job_id, message, code = RulesEngine::Audit::AUDIT_INFO)
        if perform_audit?(code)
          ReJobAudit.create({
            :job_id => job_id,
            :created_at => Time.now,  
            :code => code,
            :message => message});
        end  
      end
  
      def history(job_id)
        job_audits = ReJobAudit.by_job_id(job_id).order_id('ASC').order_date('ASC').find(:all).map do |job_audit| 
                                  {:job_id => job_audit.job_id || '', 
                                    :created => job_audit.created_at.utc.to_s, 
                                    :code => job_audit.code, 
                                    :message => job_audit.message}
                                  end
        {:job_audits => job_audits}.to_json
      end    
    end  
  end  
end