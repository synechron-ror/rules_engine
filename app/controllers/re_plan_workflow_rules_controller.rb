class RePlanWorkflowRulesController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'
  
  # before_filter :login_required
  before_filter :rules_engine_editor_access_required, :except => [:help, :error]
  before_filter :rules_engine_reader_access_required, :only => [:help, :error]

  before_filter do |controller|
    controller.re_load_model :re_plan, {:param_id => :re_plan_id, :redirect_path => :re_workflows_path}
  end
  
  before_filter do |controller|
    controller.re_load_model :re_workflow, {:param_id => :workflow_id, :parents => [:re_plan], :redirect_path => :re_plan_path, :validate => :has_plan?}
  end
  
  before_filter :only => [:edit, :update, :destroy, :move_up, :move_down] do |controller|
    controller.re_load_model :re_rule, {:param_id => :id, :parents => [:re_plan, :re_workflow], :redirect_path => :re_plan_workflow_path}
  end    
  
  def help
    @rule_class = RulesEngine::Discovery.rule_class(params[:rule_class_name])
    if @rule_class.nil?
      flash[:error] = "#{params[:rule_class]} : class not found."
      render :error
    else
      @rule = @rule_class.new  
    end
  end  
  
  def error
  end  
  
  def new
    @re_rule = ReRule.new(:re_workflow_id => @re_workflow.id, :rule_class_name => params[:rule_class_name])
    if @re_rule.rule.nil? 
      render :action => "error"
      return
    end
    
    render :action => "new"      
  end
  
  def create
    @re_rule = ReRule.new(:re_workflow_id => @re_workflow.id, :rule_class_name => params[:rule_class_name])
    if @re_rule.rule.nil? 
      render :action => "error"
      return      
    end
    
    @re_rule.rule_attributes = params
    if @re_rule.valid? && @re_rule.save
      flash[:success] = 'Rule Created.'      
    
      respond_to do |format|
        format.html do          
          redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
        end  
        format.js do
          render :action => "update"
        end
      end
    else
      render :action => "new"
    end
  end

  def edit
    if @re_rule.rule.nil? 
      render :action => "error"
      return
    end
    
    render :action => "edit"      
  end

  def update
    if @re_rule.rule.nil? 
      render :action => "error"
      return
    end
    
    @re_rule.rule_attributes = params
    if @re_rule.valid? && @re_rule.save
      flash[:success] = 'Rule Updated.'      
      
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
    @re_rule.destroy
    flash[:success] = 'Rule Deleted.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
      end  
      format.js do
        render :action => "update"
      end
    end
    
  end
  
  def move_up
    @re_rule.move_higher
    flash[:success] = 'Rule Moved Up.'      
    
    respond_to do |format|
      format.html do          
        redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def move_down
    @re_rule.move_lower
    flash[:success] = 'Rule Moved Down.'      
    
    respond_to do |format|
      format.html do          
        redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
      end  
      format.js do
        render :action => "update"
      end
    end
  end
end
