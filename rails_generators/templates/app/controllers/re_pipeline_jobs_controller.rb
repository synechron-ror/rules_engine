class RePipelineJobsController < ApplicationController    
  helper :re_pipeline 
  layout 'rules_engine'
  
  before_filter do |controller|
    controller.re_load_model :re_pipeline, {:param_id => :re_pipeline_id, :redirect_path => :re_pipelines_path}    
  end
  before_filter :only => [:show] do |controller|
    controller.re_load_model :re_job
  end    
  
  # before_filter :login_required
  before_filter :re_reader_access_required

  def index
    @re_jobs = ReJob.find_jobs_by_pipeline(@re_pipeline.id, :page => params[:page], :per_page => 20)
  end

end
