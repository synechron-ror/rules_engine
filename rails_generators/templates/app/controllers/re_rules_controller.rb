class ReRulesController < ApplicationController    
  helper :re_pipeline 
  layout 'rules_engine'
  
  before_filter do |controller|
    controller.re_load_model :re_pipeline, {:param_id => :re_pipeline_id, :redirect_path => :re_pipelines_path}    
  end
  before_filter :only => [:edit, :update, :destroy, :move_up, :move_down] do |controller|
    controller.re_load_model :re_rule, {:param_id => :id, :parents => [:re_pipeline], :redirect_path => :re_pipeline_path}
  end    
  before_filter :load_rule_class_from_rule_class,  :only => [:help, :new, :create]
  before_filter :load_rule_class_from_model,       :only => [:edit, :update, :move_up, :move_down]
  
  # before_filter :login_required
  before_filter :re_editor_access_required, :except => [:error, :help]
  before_filter :re_reader_access_required, :only => [:error, :help]

  def error
  end  
  
  def help
  end  
  
  def new
    @re_rule = ReRule.new(:re_pipeline_id => @re_pipeline.id)
  end
  
  def create
    @re_rule = ReRule.new(:re_pipeline_id => @re_pipeline.id)
    @rule.attributes = params
    if @rule.valid? && @rule.save(@re_rule) && @re_rule.save
      flash[:success] = 'Rule Created.'      
      @rule.after_create(@re_rule)
      
      respond_to do |format|
        format.html do          
          redirect_to(change_re_pipeline_path(@re_pipeline))
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
  end

  def update
    @rule.attributes = params      
    if @rule.valid? && @rule.save(@re_rule) && @re_rule.save
      @re_pipeline.changed
      flash[:success] = 'Rule Updated.'      
      @rule.after_update(@re_rule)
      
      respond_to do |format|
        format.html do          
          redirect_to(change_re_pipeline_path(@re_pipeline))
        end  
        format.js do
          render :action => "update"
        end
      end
    else
      render :action => "new"
    end
  end

  def destroy
    @rule_class = RulesEngine::Discovery.rule_class(@re_rule.rule_class)
    if (@rule_class)
      @rule = @rule_class.new  
      @rule.before_destroy(@re_rule)
    end  
    @re_rule.destroy
    @re_pipeline.changed
    flash[:success] = 'Rule Deleted.'

    respond_to do |format|
      format.html do
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "destroy"
      end
    end
    
  end
  
  def move_up
    @re_rule.move_higher
    @re_pipeline.changed
    flash[:success] = 'Rule Moved Up.'      
    
    respond_to do |format|
      format.html do          
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "update"
      end
    end
  end

  def move_down
    @re_rule.move_lower
    @re_pipeline.changed
    flash[:success] = 'Rule Moved Down.'      
    
    respond_to do |format|
      format.html do          
        redirect_to(change_re_pipeline_path(@re_pipeline))
      end  
      format.js do
        render :action => "update"
      end
    end
  end
  
  protected
    def load_rule_class_from_rule_class
      @rule_class = RulesEngine::Discovery.rule_class(params[:rule_class])
      if @rule_class.nil?
        flash[:error] = "#{params[:rule_class]} : class not found."
        render :action => :error
      else
        @rule = @rule_class.new  
      end      
    end

    def load_rule_class_from_model
      @rule_class = RulesEngine::Discovery.rule_class(@re_rule.rule_class)
      if @rule_class.nil?
        flash[:error] = "#{@re_rule.rule_class} : class not found."
        render :action => :error
      else
        @rule = @rule_class.new  
        render :action => :error unless @rule.load(@re_rule)
      end      
    end
end
