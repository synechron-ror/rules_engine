class ReJobAudit < ActiveRecord::Base

  AUDIT_PIPELINE_START  = 1
  AUDIT_PIPELINE_END =    2
  AUDIT_PIPELINE_INFO =   3
  AUDIT_RULE_START  =     4
  AUDIT_RULE_END =        5
  AUDIT_RULE_INFO =       6
  
  belongs_to :re_job
  belongs_to :re_pipeline
  belongs_to :re_rule
  
  validates_presence_of :audit_date
  validates_presence_of :audit_code
  # validates_presence_of :audit_success
    
  named_scope :by_re_job_id, lambda {|re_job_id| {:conditions => ['re_job_id = ?', re_job_id]} }
  named_scope :order_date, lambda {|order| {:order => "audit_date #{order}"} }
  
end
