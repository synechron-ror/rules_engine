class ReJob < ActiveRecord::Base
  
  JOB_STATUS_NONE = 0
  JOB_STATUS_RUNNING = 1
  JOB_STATUS_SUCCESS = 2
  JOB_STATUS_FAILED = 3
  
  
  has_many :re_job_audits
  
  validates_presence_of :job_status
  
  
  def self.find_jobs_by_pipeline re_pipeline_id, options = {}
    sql_count = <<-END_OF_STRING    
        SELECT COUNT(rej.id) AS total
        FROM re_jobs rej 
        WHERE rej.id IN ( 
          SELECT rejas.re_job_id
            FROM re_job_audits rejas 
            WHERE rejas.audit_code = #{ReJobAudit::AUDIT_PIPELINE_START} 
            AND rejas.re_pipeline_id = #{re_pipeline_id}
        )    
    END_OF_STRING
                                  
    total_entries = find_by_sql(sql_count).first.total
                                  
    paginate re_pipeline_id, options.reverse_merge(:finder => 'find_jobs_by_pipeline_paginate', :offset => 0, :limit => 20, :total_entries => total_entries)
  end
  
  def self.find_jobs_by_pipeline_paginate re_pipeline_id, options = {:offset=>0, :limit=>100}
    sql_select = <<-END_OF_STRING    
        SELECT  rej.id AS job_id, 
                rej.job_status AS job_status,
                rej.created_at AS job_date
        FROM re_jobs rej 
        WHERE rej.id IN ( 
          SELECT rejas.re_job_id
            FROM re_job_audits rejas 
            WHERE rejas.audit_code = #{ReJobAudit::AUDIT_PIPELINE_START} 
            AND rejas.re_pipeline_id = #{re_pipeline_id}
        )    
        ORDER BY job_date DESC    
    END_OF_STRING
    
    query = add_limit!(sql_select, :offset => options[:offset], :limit=>options[:limit])
      
    ActiveRecord::Base.connection.select_all(query).map do | result |

      job_audit = ReJobAudit.find(:all, :conditions => ["re_job_id = ? AND audit_code = ? AND re_pipeline_id = ?", result['job_id'], ReJobAudit::AUDIT_PIPELINE_START, re_pipeline_id], :order => "audit_date ASC", :limit => 1).first
      result.merge!({
        'start_date' => job_audit.audit_date,
        'start_data' => job_audit.audit_data, 
        'start_success' => job_audit.audit_success
      })

      job_audit = ReJobAudit.find(:all, :conditions => ["re_job_id = ? AND audit_code = ? AND re_pipeline_id = ?", result['job_id'], ReJobAudit::AUDIT_PIPELINE_END, re_pipeline_id], :order => "audit_date ASC", :limit => 1).first
      if (job_audit)
        result.merge!({
          'end_date' => job_audit.audit_date,
          'end_data' => job_audit.audit_data, 
          'end_success' => job_audit.audit_success
        })
      end

      result
    end
  end

  def self.find_jobs options = {}
    sql_count = <<-END_OF_STRING    
        SELECT COUNT(rej.id) AS total
        FROM re_jobs rej 
        WHERE rej.id IN ( 
          SELECT rejas.re_job_id
            FROM re_job_audits rejas 
            WHERE rejas.audit_code = #{ReJobAudit::AUDIT_PIPELINE_START} 
        )            
    END_OF_STRING
                                  
    total_entries = find_by_sql(sql_count).first.total
                                  
    paginate options.reverse_merge(:finder => 'find_jobs_paginate', :page => 0, :per_page => 20, :total_entries => total_entries)
  end
  
  def self.find_jobs_paginate options = {:offset=>0, :limit=>100}
    sql_select = <<-END_OF_STRING    
        SELECT  rej.id AS job_id, 
                rej.job_status AS job_status,
                rej.created_at AS job_date                
        FROM re_jobs rej 
        WHERE rej.id IN ( 
          SELECT rejas.re_job_id
            FROM re_job_audits rejas 
            WHERE rejas.audit_code = #{ReJobAudit::AUDIT_PIPELINE_START} 
        )    
        ORDER BY job_date DESC    
    END_OF_STRING
    
    query = add_limit!(sql_select, :offset => options[:offset], :limit=>options[:limit])
      
    ActiveRecord::Base.connection.select_all(query).map do | result |

      job_audit = ReJobAudit.find(:all, :conditions => ["re_job_id = ? AND audit_code = ?", result['job_id'], ReJobAudit::AUDIT_PIPELINE_START], :order => "audit_date ASC", :limit => 1).first
      result.merge!({
        'start_date' => job_audit.audit_date,
        'start_data' => job_audit.audit_data, 
        'start_success' => job_audit.audit_success
      })

      job_audit = ReJobAudit.find(:all, :conditions => ["re_job_id = ? AND audit_code = ?", result['job_id'], ReJobAudit::AUDIT_PIPELINE_END], :order => "audit_date DESC", :limit => 1).first
      if (job_audit)
        result.merge!({
          'end_date' => job_audit.audit_date,
          'end_data' => job_audit.audit_data, 
          'end_success' => job_audit.audit_success
        })
      end

      result
    end
  end
end
