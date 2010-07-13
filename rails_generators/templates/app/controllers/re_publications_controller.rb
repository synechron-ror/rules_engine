class RePublicationsController < ApplicationController    
  helper :rules_engine 
  layout 'rules_engine'

  # before_filter :login_required
  before_filter :rules_engine_reader_access_required,  :only => [:show]

  before_filter :only => [:show] do |controller|
    controller.re_load_model :re_plan
  end    

  def show
    @re_publications = RulesEngine::Publish.publisher.versions(@re_plan.code)[0..10]    
  end
end
