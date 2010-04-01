class ReJobsController < ApplicationController    

  before_filter :only => [:show] do |controller|
    controller.load_model :re_job
  end    
  
  # before_filter :login_required
  before_filter :reader_access_required

  def index
    @re_jobs = ReJob.find_jobs(:page => params[:page], :per_page => 2)
  end

  def show
    @re_job_audits = ReJobAudit.by_re_job_id(params[:id]).order_date('ASC').find(:all, :include => [:re_pipeline] )
  end

end
