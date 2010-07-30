class RePlansController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :edit, :update, :destroy, :change, :publish, :revert, :copy, :duplicate]
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show, :preview, :re_process]

  before_filter :only => [:show, :edit, :update, :destroy, :change, :preview, :publish, :revert, :re_process, :copy, :duplicate] do |controller|
    controller.re_load_model :re_plan
  end    

  def index    
    klass = RePlan
    klass = klass.order_title
    @re_plans = klass.find(:all)
  end

  def show
  end

  def new
    @re_plan = RePlan.new
  end
  
  def create
    @re_plan = RePlan.new(params[:re_plan])
    
    if @re_plan.save
      flash[:success] = 'Plan Created.'
      
      respond_to do |format|
        format.html do
          redirect_to(change_re_plan_path(@re_plan))
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
    update_params = params[:re_plan] || {}
    @re_plan.attributes = update_params.except(:code)
    if @re_plan.save
      flash[:success] = 'Plan Updated.'
      
      respond_to do |format|
        format.html do          
          redirect_to(change_re_plan_path(@re_plan))
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
    RulesEngine::Publish.publisher.remove(@re_plan.code)
    @re_plan.destroy
    flash[:success] = 'Plan Deleted.'
    
    respond_to do |format|
      format.html do
        redirect_to(re_plans_path)
      end  
      format.js do
        render :inline => "window.location.href = '#{re_plans_path}';"
      end
    end
  end

  def change
  end
  
  def preview
  end

  def publish
    if params['tag'].blank?
      flash[:error] = 'Tag Required.'
    else  
      @re_plan.plan_version = RulesEngine::Publish.publisher.publish(@re_plan.code, params['tag'], @re_plan.publish)
      @re_plan.plan_status = RePlan::PLAN_STATUS_PUBLISHED
      @re_plan.save
      flash[:success] = 'Plan Published.'
    end  
  
    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def revert
    plan = RulesEngine::Publish.publisher.get(@re_plan.code)    
    if plan.nil?
      flash[:error] = 'Cannot Find Published Plan.'
    else
      @re_plan.revert!(plan)
      @re_plan.save!
      flash[:success] = 'Changes Discarded.'
    end  
    
    respond_to do |format|
      format.html do
        redirect_to(change_re_plan_path(@re_plan))
      end  
      format.js do
        render :action => "update"
      end
    end
  end
  
  def re_process
    @re_processes = RulesEngine::Process.runner.history(@re_plan.code, :page => params[:page] || 1, :per_page => 5)    
  end

  def copy
    @re_plan_new = RePlan.new
  end

  def duplicate
    @re_plan_new = RePlan.new
    @re_plan_new.revert!(@re_plan.publish)
    @re_plan_new.attributes = params[:re_plan]

    if @re_plan_new.save    
      flash[:success] = 'Plan Duplicated.'
      respond_to do |format|
        format.html do
          redirect_to(change_re_plan_path(@re_plan_new))
        end  
        format.js do
          render :inline => "window.location.href = '#{change_re_plan_path(@re_plan_new)}';"
        end
      end
    else
       render :action => "copy"  
    end  
  end
end
