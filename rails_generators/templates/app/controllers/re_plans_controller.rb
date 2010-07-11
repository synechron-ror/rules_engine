class RePlansController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_editor_access_required,  :only => [:new, :create, :edit, :update, :destroy, :change, :publish_all, :publish, :deactivate, :revert]
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show]

  before_filter :only => [:show, :edit, :update, :destroy, :change, :publish, :deactivate, :revert] do |controller|
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
  
  def publish_all
    klass = RePlan
    @re_plans = klass.find(:all)
    
    if @re_plans.any? { | re_plan| re_plan.plan_error }
      flash[:error] = 'Cannot Publish Plans.'
    else
      @re_plans.each do |re_plan|
        re_plan.publish!
      end
      flash[:success] = 'All Plans Published.'
    end
      
    respond_to do |format|
      format.html do
        redirect_to(re_plans_path)
      end  
      format.js do
        render :action => "index"
      end
    end    
  end
  
  def publish
    if @re_plan.plan_error
      flash[:error] = 'Cannot Publish Plan.'
    else  
      @re_plan.publish!
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

  def deactivate
    @re_plan.deactivate!
    flash[:success] = 'Plan Deactivated.'
  
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
    @re_plan.revert!
    flash[:success] = 'Plan Changes Removed.'
    
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
