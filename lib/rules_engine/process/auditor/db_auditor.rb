module RulesEngine
  module Process
    class ReProcessAudit < ActiveRecord::Base
  
      validates_presence_of :code
    
      named_scope :by_process_id, lambda {|process_id| {:conditions => ['process_id = ?', process_id]} }
      # named_scope :order_id, lambda {|order| {:order => "id #{order}"} }
      named_scope :order_created_at, lambda {|order| {:order => "created_at #{order}, id #{order}"} }
    end

    class DbAuditor < Auditor

      def initialize(*options)        
      end
      
      def audit(process_id, message, code = RulesEngine::Process::AUDIT_INFO)
        if perform_audit?(code)
          ReProcessAudit.create({
            :process_id => process_id,
            :created_at => Time.now,  
            :code => code,
            :message => message});
        end  
      end
  
      def history(process_id)
        klass = ReProcessAudit
        klass = klass.by_process_id(process_id)
        # klass = klass.order_id('ASC')
        klass = klass.order_created_at('ASC')
        
        klass.find(:all).map do |re_process_audit| 
                                  {"process_id" => re_process_audit.process_id, 
                                    "created_at" => re_process_audit.created_at.utc.to_s, 
                                    "code" => re_process_audit.code, 
                                    "message" => re_process_audit.message}
                                  end
      end    
    end  
  end  
end