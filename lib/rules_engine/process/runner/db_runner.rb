require 'will_paginate'

module RulesEngine
  module Process
    
    class ReProcessRun < ActiveRecord::Base
      validates_presence_of :process_status
      
      scope :by_plan_code, lambda {|plan_code| where('plan_code = ?', plan_code) }
      scope :by_process_status_gt, lambda {|process_status| where("process_status > #{process_status}") }
      scope :order_started_at, lambda {|order| order("started_at #{order}, id #{order}") }
      
      def self.history(plan_code, options = {})

        klass = self
        klass = klass.by_plan_code(plan_code) unless plan_code.nil?
        klass = klass.by_process_status_gt(RulesEngine::Process::PROCESS_STATUS_NONE)
        klass = klass.order_started_at('DESC')
                
        klass.paginate({:page => 1, :per_page => 10}.merge(options))
      end
    end
    
      
    class DbRunner < Runner

      def initialize(*options)        
      end
      
      def create()
        ReProcessRun.create(:process_status => RulesEngine::Process::PROCESS_STATUS_NONE).id
      end
      
      def run_plan(process_id, plan, data = {})
        re_process = ReProcessRun.find_by_id(process_id)

        if re_process.nil?
          RulesEngine::Process.auditor.audit(process_id, "Process missing", RulesEngine::Process::AUDIT_FAILURE)
          return false
        end
        
        re_process.update_attributes(:plan_code => plan["code"], :plan_version => plan["version"], :started_at => Time.now.utc, :process_status => RulesEngine::Process::PROCESS_STATUS_RUNNING)  
        
        success = super(process_id, plan, data)
        
        re_process.update_attributes(:finished_at => Time.now.utc, :process_status => success ? RulesEngine::Process::PROCESS_STATUS_SUCCESS : RulesEngine::Process::PROCESS_STATUS_FAILURE)
      
        success
      end
      
      def status(process_id)
        re_process = ReProcessRun.find_by_id(process_id)
        re_process ? re_process.process_status : RulesEngine::Process::PROCESS_STATUS_NONE
      end      
   
   
      def history(plan_code = nil, options = {})
        
        re_process_runs = ReProcessRun.history(plan_code, options)

        {  "next_page" => re_process_runs.next_page, 
           "previous_page" => re_process_runs.previous_page,
           "processes" => re_process_runs.map do |re_process_run| 
              { 
                "process_id" => re_process_run.id,  
                "plan_code" => re_process_run.plan_code, 
                "plan_version" => re_process_run.plan_version, 
                "process_status" => re_process_run.process_status,  
                "started_at" => re_process_run.started_at.nil? ? nil : re_process_run.started_at.utc.to_s, 
                "finished_at" =>re_process_run.finished_at.nil? ? nil : re_process_run.finished_at.utc.to_s
              }
            end
        }
      end
      
    end  
  end  
end