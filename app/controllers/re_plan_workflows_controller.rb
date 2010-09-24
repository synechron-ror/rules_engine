class RePlanWorkflowsController < ApplicationController    
  helper :rules_engine 
  layout RulesEngineView::Config.layout || 'rules_engine'
  
  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :edit, :update, :destroy, :change, :default, :add, :remove, :copy, :duplicate]
  before_filter :rules_engine_reader_access_required,  :only => [:show]

  before_filter do |controller|
    controller.re_load_model :re_plan, {:param_id => :re_plan_id, :redirect_path => :re_plans_path}    
  end
  
  before_filter :only => [:show, :edit, :update, :destroy, :change, :default, :remove, :copy, :duplicate] do |controller|
    controller.re_load_model :re_workflow, {:parents => [:re_plan], :redirect_path => :re_plan_path, :validate => :has_plan?}
  end    
  before_filter :only => [:add] do |controller|
    controller.re_load_model :re_workflow, {:redirect_path => :change_re_plan_path}
  end    

  def show
  end

  def new
    @re_workflow = ReWorkflow.new()
  end
  
  def create
    @re_workflow = ReWorkflow.new(params[:re_workflow])    
    if @re_workflow.save
      @re_plan.add_workflow(@re_workflow)
      flash[:success] = 'Workflow Created.'
      
      respond_to do |format|
        format.html do
          redirect_to(change_re_plan_path(@re_plan))
        end  
        format.js do
          render :template => "re_plans/update"
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
          redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
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
    flash[:success] = 'Workflow Deleted.'
    
    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :inline => "window.location.href = '#{change_re_plan_path(@re_plan)}';"
      end
    end
  end

  def change
    RulesEngine::Discovery.discover!
  end
  
  def default
    @re_plan.default_workflow = @re_workflow
    
    flash[:success] = 'Workflow Default Set.'
    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :template => "re_plans/update"
      end
    end
  end

  def add
    @re_plan.add_workflow(@re_workflow)    
    flash[:success] = 'Workflow Added.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :template => "re_plans/update"
      end
    end
  end

  def remove    
    @re_plan.remove_workflow(@re_workflow)
    flash[:success] = 'Workflow Removed.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :template => "re_plans/update"
      end
    end
  end
  
  def copy
    @re_workflow_copy = ReWorkflow.new
  end

  def duplicate
    @re_workflow_copy = ReWorkflow.new
    @re_workflow_copy.revert!(@re_workflow.publish)
    @re_workflow_copy.attributes = params[:re_workflow]

    if @re_workflow_copy.save   
      @re_plan.add_workflow(@re_workflow_copy) 
      flash[:success] = 'Workflow Duplicated.'
      respond_to do |format|
        format.html do
          redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow_copy))
        end  
        format.js do
          render :inline => "window.location.href = '#{change_re_plan_workflow_path(@re_plan, @re_workflow_copy)}';"
        end
      end
    else
       render :action => "copy"  
    end  
  end

end
