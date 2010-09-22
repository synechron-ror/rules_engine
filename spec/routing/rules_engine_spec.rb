require 'spec_helper'

describe "routing to profiles" do
  extend RulesEngine::RouteMatcher
  
  describe "/re_plans" do
    # index methods
    match_route(:get,  :re_plans, :index => '/re_plans')
    match_route(:get,  :re_plans, :new => '/re_plans/new')
    match_route(:post, :re_plans, :create => '/re_plans')

    with_route_params(:id => "101") do
      match_route(:get, :re_plans, :show => '/re_plans/101', 
                                  :edit => '/re_plans/101/edit')
      match_route(:put, :re_plans, :update => '/re_plans/101')
      match_route(:delete, :re_plans, :destroy => '/re_plans/101')
    
      match_route(:get,  :re_plans, :change => '/re_plans/101/change', 
                                     :preview => "/re_plans/101/preview",
                                     :history => "/re_plans/101/history")
    
      match_route(:put,  :re_plans, :publish => '/re_plans/101/publish', 
                                     :revert => '/re_plans/101/revert')
    
      match_route(:get,  :re_plans,  :copy => '/re_plans/101/copy')
      match_route(:post,  :re_plans, :duplicate => '/re_plans/101/duplicate')
    end
  end    
  
  describe "/re_plans/101/workflows" do
    with_route_params(:re_plan_id => "101") do
      match_route(:get,  :re_plan_workflows, :new => '/re_plans/101/workflows/new')
      match_route(:post, :re_plan_workflows, :create => '/re_plans/101/workflows')
    end
    with_route_params(:re_plan_id => "101", :id => "202") do  
      match_route(:get, :re_plan_workflows, :show => '/re_plans/101/workflows/202', 
                                            :edit => '/re_plans/101/workflows/202/edit')
      match_route(:put, :re_plan_workflows, :update => '/re_plans/101/workflows/202')
      match_route(:delete, :re_plan_workflows, :destroy => '/re_plans/101/workflows/202')
      
      match_route(:get, :re_plan_workflows, :change => '/re_plans/101/workflows/202/change')
      match_route(:put, :re_plan_workflows, :default => '/re_plans/101/workflows/202/default')
      match_route(:put, :re_plan_workflows, :add => '/re_plans/101/workflows/202/add')
      match_route(:put, :re_plan_workflows, :remove => '/re_plans/101/workflows/202/remove')
      match_route(:get, :re_plan_workflows, :copy => '/re_plans/101/workflows/202/copy')
      match_route(:post, :re_plan_workflows, :duplicate => '/re_plans/101/workflows/202/duplicate')      
    end
  end

  describe "/re_plans/101/workflows/202/rules" do
    with_route_params(:re_plan_id => "101", :workflow_id => "202") do
      match_route(:get,  :re_plan_workflow_rules, :new => '/re_plans/101/workflows/202/rules/new')
      match_route(:post, :re_plan_workflow_rules, :create => '/re_plans/101/workflows/202/rules')

      match_route(:get, :re_plan_workflow_rules, :help => '/re_plans/101/workflows/202/rules/help')
      match_route(:get, :re_plan_workflow_rules, :error => '/re_plans/101/workflows/202/rules/error')      
    end
    with_route_params(:re_plan_id => "101", :workflow_id => "202", :id => "303") do  
      match_route(:get, :re_plan_workflow_rules, :edit => '/re_plans/101/workflows/202/rules/303/edit')
      match_route(:put, :re_plan_workflow_rules, :update => '/re_plans/101/workflows/202/rules/303')
      match_route(:delete, :re_plan_workflow_rules, :destroy => '/re_plans/101/workflows/202/rules/303')

      match_route(:put, :re_plan_workflow_rules, :move_up => '/re_plans/101/workflows/202/rules/303/move_up')
      match_route(:put, :re_plan_workflow_rules, :move_down => '/re_plans/101/workflows/202/rules/303/move_down')
    end
  end

  describe "/re_workflows" do
    # index methods
    match_route(:get,  :re_workflows, :index => '/re_workflows')
    match_route(:get,  :re_workflows, :new => '/re_workflows/new')
    match_route(:post, :re_workflows, :create => '/re_workflows')
    match_route(:get,  :re_workflows, :add => '/re_workflows/add')

    with_route_params(:id => "101") do
      match_route(:get, :re_workflows, :show => '/re_workflows/101', 
                                        :edit => '/re_workflows/101/edit')
      match_route(:put, :re_workflows, :update => '/re_workflows/101')
      match_route(:delete, :re_workflows, :destroy => '/re_workflows/101')
    
      match_route(:get,  :re_workflows, :plan => '/re_workflows/101/plan', 
                                        :change => '/re_workflows/101/change', 
                                        :preview => "/re_workflows/101/preview")
          
      match_route(:get,  :re_workflows,  :copy => '/re_workflows/101/copy')
      match_route(:post,  :re_workflows, :duplicate => '/re_workflows/101/duplicate')
    end
  end    

  describe "/re_workflows/101/rules" do
    with_route_params(:re_workflow_id => "101") do
      match_route(:get,  :re_workflow_rules, :new => '/re_workflows/101/rules/new')
      match_route(:post, :re_workflow_rules, :create => '/re_workflows/101/rules')

      match_route(:get, :re_workflow_rules, :help => '/re_workflows/101/rules/help')
      match_route(:get, :re_workflow_rules, :error => '/re_workflows/101/rules/error')      
    end
    with_route_params(:re_workflow_id => "101", :id => "202") do  
      match_route(:get, :re_workflow_rules, :edit => '/re_workflows/101/rules/202/edit')
      match_route(:put, :re_workflow_rules, :update => '/re_workflows/101/rules/202')
      match_route(:delete, :re_workflow_rules, :destroy => '/re_workflows/101/rules/202')

      match_route(:put, :re_workflow_rules, :move_up => '/re_workflows/101/rules/202/move_up')
      match_route(:put, :re_workflow_rules, :move_down => '/re_workflows/101/rules/202/move_down')
    end
  end

  
  describe "/re_history" do
    match_route(:get, :re_history, :index => '/re_history')
    with_route_params(:id => "101") do  
      match_route(:get, :re_history, :show => '/re_history/101')
    end  
  end
  
  describe "/re_publications" do
    match_route(:get, :re_publications, :show => '/re_publications')
  end
end
