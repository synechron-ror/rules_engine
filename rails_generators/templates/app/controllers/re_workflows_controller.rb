class ReWorkflowsController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'
  
  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :edit, :update, :destroy, :change, :copy, :duplicate]
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show, :preview, :plan, :add]

  before_filter :only => [:show, :edit, :update, :destroy, :change, :preview, :plan, :copy, :duplicate] do |controller|
    controller.re_load_model :re_workflow
  end    

  def index
    @re_workflows = ReWorkflow.order_title.find(:all)
  end
  
  def show
  end

  def new
    @re_workflow = ReWorkflow.new
  end
  
  def create
    @re_workflow = ReWorkflow.new(params[:re_workflow])
    
    if @re_workflow.save
      flash[:success] = 'Workflow Created.'
      
      respond_to do |format|
        format.html do
          redirect_to(change_re_workflow_path(@re_workflow))
        end  
        format.js do
          render :action => "create"
        end
      end
    else
      render :action => "new"
    end    
  end

  def edit    
  end

  def update
    update_params = params[:re_workflow] || {}
    @re_workflow.attributes = update_params.except(:code)
    if @re_workflow.save
      flash[:success] = 'Workflow Updated.'
      
      respond_to do |format|
        format.html do          
          redirect_to(change_re_workflow_path(@re_workflow))
        end  
        format.js do
          render :action => "update"
        end
      end
    else
      render :action => "edit"
    end    
  end

  def destroy
    @re_workflow.destroy
    flash[:success] = 'Workflow Removed.'
    
    respond_to do |format|
      format.html do
        redirect_to(re_workflows_path)
      end  
      format.js do
        render :inline => "window.location.href = '#{re_workflows_path}';"
      end
    end
  end

  def change
    RulesEngine::Discovery.discover!
  end
  
  def preview
  end

  def plan
    klass = RePlanWorkflow
    klass = klass.order_plan_title
    klass = klass.by_workflow_id(@re_workflow.id)
    @re_plan_workflows = klass.paginate(:include => :re_plan, :page => params[:page] || 1, :per_page => 10)
  end

  def add
    @re_workflows = ReWorkflow.order_title.find(:all)
  end
  
  def copy
    @re_workflow_new = ReWorkflow.new
  end

  def duplicate
    @re_workflow_new = ReWorkflow.new
    @re_workflow_new.revert!(@re_workflow.publish)
    @re_workflow_new.attributes = params[:re_workflow]

    if @re_workflow_new.save    
      flash[:success] = 'Workflow Duplicated.'
      respond_to do |format|
        format.html do
          redirect_to(change_re_workflow_path(@re_workflow_new))
        end  
        format.js do
          render :inline => "window.location.href = '#{change_re_workflow_path(@re_workflow_new)}';"
        end
      end
    else
       render :action => "copy"  
    end  
  end
  
end
