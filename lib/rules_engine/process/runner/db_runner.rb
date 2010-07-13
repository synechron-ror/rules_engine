module RulesEngine
  module Process
    
    class ReProcessRun < ActiveRecord::Base
      validates_presence_of :process_status
      
      named_scope :by_plan_code, lambda {|plan_code| {:conditions => ['plan_code = ?', plan_code]} }
      named_scope :by_process_status_gt, lambda {|process_status| {:conditions => "process_status > #{process_status}"} }
      # named_scope :order_id, lambda {|order| {:order => "id #{order}"} }
      named_scope :order_started_at, lambda {|order| {:order => "started_at #{order}, id #{order}"} }
      named_scope :order_finished_at, lambda {|order| {:order => "finished_at #{order}, id #{order}"} }      
    end
    
      
    class DbRunner < Runner

      def initialize(*options)        
      end
      
      def create()
        ReProcessRun.create(:process_status => RulesEngine::Process::PROCESS_STATUS_NONE).id
      end
      
      def run(process_id, plan, data = {})
        re_process = ReProcessRun.find_by_id(process_id)

        if re_process.nil?
          RulesEngine::Process.auditor.audit(process_id, "Process missing", RulesEngine::Process::AUDIT_FAILURE)
          return false
        end
        
        re_process.update_attributes(:plan_code => plan["code"], :started_at => Time.now.utc, :process_status => RulesEngine::Process::PROCESS_STATUS_RUNNING)  
        
        success = super
        
        re_process.update_attributes(:finished_at => Time.now.utc, :process_status => success ? RulesEngine::Process::PROCESS_STATUS_SUCCESS : RulesEngine::Process::PROCESS_STATUS_FAILURE)
      
        success
      end
      
      def status(process_id)
        re_process = ReProcessRun.find_by_id(process_id)
        re_process ? re_process.process_status : RulesEngine::Process::PROCESS_STATUS_NONE
      end      
   
   
      def history(plan_code = nil, page = 1, page_size = 20)
        klass = ReProcessRun
        klass = klass.by_plan_code(plan_code) unless plan_code.nil?
        klass = klass.by_process_status_gt(RulesEngine::Process::PROCESS_STATUS_RUNNING)
        # klass = klass.order_id('DESC')
        klass = klass.order_started_at('DESC')
        
        re_process_runs = klass.paginate(:page => page, :per_page => page_size)        
        processs = re_process_runs.map do |re_process_run| 
                                  {"process_id" => re_process_run.id,  
                                    "plan_code" => re_process_run.plan_code, 
                                    "process_status" => re_process_run.process_status,  
                                    "created_at" => re_process_run.created_at.utc.to_s, 
                                    "started_at" => re_process_run.started_at.nil? ? nil : re_process_run.started_at.utc.to_s, 
                                    "finished_at" =>re_process_run.finished_at.nil? ? nil : re_process_run.finished_at.utc.to_s}
                                  end  
        {"page" => page, 
           "page_size" => page_size,
           "next_page" => re_process_runs.next_page, 
           "previous_page" => re_process_runs.previous_page,
           "processes" => processs
        }
      end
      
    end  
  end  
end