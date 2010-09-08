class ReHistoryController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_reader_access_required,  :only => [:index, :show]

  def index
    @re_history = RulesEngine::Process.runner.history(nil, :page => params[:page] || 1, :per_page => 5)
  end

  def show
    @re_audits = RulesEngine::Process.auditor.history(params[:id])
  end
end
