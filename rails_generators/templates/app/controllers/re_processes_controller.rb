class ReProcessesController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show]

  def index
    @re_processes = RulesEngine::Process.runner.history(nil, params[:page] || 1, 5)
  end

  def show
    # @re_processes = RulesEngine::Process.runner.history(@re_plan.code)
  end
end
