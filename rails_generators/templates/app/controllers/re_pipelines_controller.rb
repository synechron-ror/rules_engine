class RePipelinesController < ApplicationController    
  helper :re_pipeline 
  layout 'rules_engine'
  
  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :change, :edit, :update, :activate_all, :activate, :deactivate, :revert, :destroy]
  before_filter :rules_engine_reader_access_required,  :only => [:lookup, :index, :show]

  before_filter :only => [:show, :change, :edit, :update, :activate, :deactivate, :revert, :destroy] do |controller|
    controller.re_load_model :re_pipeline
  end    

  def lookup
    klass = RePipeline
    query = params[:q] || ''
    if params[:t] == 'code'
      if query.blank?
        render :text => klass.find(:all, :order => "code", :limit => 10 ).map(&:code).join("\n")
      else
        render :text => klass.find(:all, :conditions => ["code LIKE ?", "#{query}%"], :order => "code", :limit => 10 ).map(&:code).join("\n")
      end
    else # params[:t] == 'title'
      if query.blank?
        render :text => klass.find(:all, :order => "title", :limit => 10 ).map(&:title).join("\n")
      else
        render :text => klass.find(:all, :conditions => ["title LIKE ?", "#{query}%"], :order => "title", :limit => 10 ).map(&:title).join("\n")
      end
    end  
  end

    
  def index    
    klass = RePipeline
    @re_pipelines = klass.find(:all)
  end
  
  def show
  end

  def new
    @re_pipeline = RePipeline.new
  end
  
  def create
    @re_pipeline = RePipeline.new(params[:re_pipeline])
    
    if @re_pipeline.save
      flash[:success] = 'Pipeline Created.'
      
      respond_to do |format|
        format.html do
          redirect_to(change_re_pipeline_path(@re_pipeline))
        end  
        format.js do
          render :action => "create"
        end
      end
    else
      render :action => "new"
    end    
  end

  def change
  end
  
  def edit    
  end

  def update
    update_params = params[:re_pipeline] || {}
    @re_pipeline.attributes = update_params.except(:code)
    if @re_pipeline.save
      flash[:success] = 'Pipeline Updated.'
      
      respond_to do |format|
        format.html do          
          redirect_to(change_re_pipeline_path(@re_pipeline))
        end  
        format.js do
          render :action => "update"
        end
      end
    else
      render :action => "edit"
    end    
  end

  def activate_all
    klass = RePipeline
    @re_pipelines = klass.find(:all)
    
    @re_pipelines.each do |re_pipeline|
      re_pipeline.activate!
    end
    flash[:success] = 'All Pipelines Activated.'

    respond_to do |format|
      format.html do
        redirect_to(re_pipelines_path)
      end  
      format.js do
        render :action => "index"
      end
    end    
  end
  
  def activate
    @re_pipeline.activate!
    flash[:success] = 'Pipeline Activated.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def deactivate
    @re_pipeline.deactivate!
    flash[:success] = 'Pipeline Deactivated.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def revert
    @re_pipeline.revert!
    flash[:success] = 'Pipeline Changes Removed.'
    
    respond_to do |format|
      format.html do
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def destroy
    @re_pipeline.destroy
    flash[:success] = 'Pipeline Removed.'
    
    respond_to do |format|
      format.html do
        redirect_to(re_pipelines_path)
      end  
      format.js do
        render :inline => "window.location.href = '#{re_pipelines_path}';"
      end
    end
  end

end
