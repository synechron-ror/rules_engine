class RePublicationsController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_reader_access_required,  :only => [:show]

  before_filter :only => [:show] do |controller|
    controller.re_load_model :re_plan
  end    

  def show
    @re_publications = RulesEngine::Publish.publisher.history(@re_plan.code, :page => params[:page] || 1, :per_page => 5)
  end
end
