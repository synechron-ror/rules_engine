class RePipelinesController < ApplicationController    

  before_filter :only => [:show, :change, :edit, :update, :activate, :deactivate, :revert, :destroy] do |controller|
    controller.load_model :re_pipeline
  end    

  # before_filter :login_required
  before_filter :editor_access_required,  :only => [:new, :create, :change, :edit, :update, :activate, :deactivate, :revert, :destroy]
  before_filter :reader_access_required,  :only => [:lookup, :index, :show]

  def lookup
    klass = RePipeline
    query = params[:q] || ''
    if params[:t] == 'code'
      if query.chomp.blank?
        render :text => klass.find(:all, :order => "title", :limit => 10 ).map(&:title).join("\n")
      else
        render :text => klass.find(:all, :conditions => ["title LIKE ?", "#{params[:q]}%"], :order => "title", :limit => 10 ).map(&:title).join("\n")
      end
    else # params[:t] == 'title'
      if query.chomp.blank?
        render :text => klass.find(:all, :order => "code", :limit => 10 ).map(&:code).join("\n")
      else
        render :text => klass.find(:all, :conditions => ["code LIKE ?", "#{params[:q]}%"], :order => "code", :limit => 10 ).map(&:code).join("\n")
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
    @re_pipeline.attributes = params[:re_pipeline].except(:code)
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
