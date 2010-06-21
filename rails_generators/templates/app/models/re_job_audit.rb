class ReJobAudit < ActiveRecord::Base

  AUDIT_INFO  =     0
  AUDIT_SUCCESS =   1
  AUDIT_FAILURE =   2
  
  belongs_to :re_job
  belongs_to :re_pipeline
  belongs_to :re_rule
  
  validates_presence_of :audit_date
  validates_presence_of :audit_code
    
  named_scope :by_re_job_id, lambda {|re_job_id| {:conditions => ['re_job_id = ?', re_job_id]} }
  named_scope :order_date, lambda {|order| {:order => "audit_date #{order}"} }
  
end
