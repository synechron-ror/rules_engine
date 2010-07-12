class RePlansController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :edit, :update, :destroy, :change, :publish, :revert]
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show, :preview]

  before_filter :only => [:show, :edit, :update, :destroy, :change, :preview, :publish, :revert] do |controller|
    controller.re_load_model :re_plan
  end    

  def index    
    klass = RePlan
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
          redirect_to(re_plans_path)
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
    if @re_plan.plan_error
      flash[:error] = 'Cannot Publish Plan.'
    else  
      @re_plan.plan_version = RulesEngine::Publish.publisher.publish(@re_plan.code, @re_plan.publish)
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
      @re_plan.plan_status = RePlan::PLAN_STATUS_REVERTED
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
end
