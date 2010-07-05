module RulesEngine
  module Job
    
    class ReJobRun < ActiveRecord::Base
      validates_presence_of :status
      
      named_scope :by_map_code, lambda {|map_code| {:conditions => ['map_code = ?', map_code]} }
      named_scope :by_status_gt, lambda {|status| {:order => "status > #{status}"} }
      named_scope :order_id, lambda {|order| {:order => "id #{order}"} }
      named_scope :order_started_at, lambda {|order| {:order => "started_at #{order}"} }
      named_scope :order_finished_at, lambda {|order| {:order => "finished_at #{order}"} }      
    end
    
      
    class DbJobRunner < Runner

      def initialize(*options)        
      end
      
      def create()
        ReJobRun.create(:status => RulesEngine::Job::JOB_STATUS_NONE).id
      end
      
      def run(job_id, map, data = {})
        re_job = ReJobRun.find_by_id(job_id)

        if re_job.nil?
          RulesEngine::job.auditor.audit(job_id, "Job missing", RulesEngine::Audit::AUDIT_FAILURE)
          return false
        end
        
        re_job.update_attributes(:map_code => map["code"], :status => RulesEngine::Job::JOB_STATUS_RUNNING)  
        
        success = super
        
        re_job.update_attributes(:status => error ? RulesEngine::Job::JOB_STATUS_FAILURE : RulesEngine::Job::JOB_STATUS_SUCCESS)
      
        !error
      end
      
      def status(job_id)
        re_job = ReJobRun.find_by_id(job_id)
        re_job ? re_job.status : RulesEngine::Job::JOB_STATUS_NONE
      end      
   
   
      def history(page = 1, page_size = 20)
        jobs = ReJobRun.by_status_gt(RulesEngine::Job::JOB_STATUS_RUNNING).order_id('DESC').order_started_at('DESC').paginate(:page => page, :per_page => page_size).map do |job| 
                                  {:map_code => job.map_code, 
                                    :status => job.status,  
                                    :created_at => job.created_at.utc.to_s, 
                                    :started_at => job.started_at.utc.to_s, 
                                    :finished_at => job.finished_at.utc.to_s}
                                  end  
        {:page => page, 
           :page_size => page_size,
           :next_page => jobs.next_page, 
           :previous_page => jobs.previous_page,
           :jobs => jobs
        }.to_json
      end
      
    end  
  end  
end