require 'spec_helper'

describe "routes" do
  extend RulesEngine::RouteMatcher
  
  describe "/re_plans" do
    match_controller(:re_plans) do
      with_route(:get, '/re_plans' => :index,
                        '/re_plans/new' => :new)
      with_route(:post, '/re_plans' => :create)
    end  

    match_controller(:re_plans, :id => "101") do
      with_route(:get, '/re_plans/101' => :show, 
                       '/re_plans/101/edit' => :edit)
      with_route(:put, '/re_plans/101' => :update)
      with_route(:delete, '/re_plans/101' => :destroy)

      with_route(:get, '/re_plans/101/change' => :change,
                       '/re_plans/101/preview' => :preview,
                       '/re_plans/101/history' => :history)
    
      with_route(:put, '/re_plans/101/publish' => :publish, 
                       '/re_plans/101/revert' => :revert)

      with_route(:get,  '/re_plans/101/copy' => :copy)
      with_route(:post, '/re_plans/101/duplicate' => :duplicate)
    end
  end    
  
  describe "/re_plans/101/workflows" do
    match_controller(:re_plan_workflows, :re_plan_id => "101") do
      with_route(:get, '/re_plans/101/workflows/new' => :new)
      with_route(:post, '/re_plans/101/workflows' => :create)
    end
    
    match_controller(:re_plan_workflows, :re_plan_id => "101", :id => "202") do  
      with_route(:get, '/re_plans/101/workflows/202' => :show, 
                       '/re_plans/101/workflows/202/edit' => :edit)
      with_route(:put, '/re_plans/101/workflows/202' => :update)
      with_route(:delete, '/re_plans/101/workflows/202' => :destroy)
      
      with_route(:get, '/re_plans/101/workflows/202/change' => :change)
      with_route(:put, '/re_plans/101/workflows/202/default' => :default)
      with_route(:put, '/re_plans/101/workflows/202/add' => :add)
      with_route(:put, '/re_plans/101/workflows/202/remove' => :remove)
      with_route(:get, '/re_plans/101/workflows/202/copy' => :copy)
      with_route(:post, '/re_plans/101/workflows/202/duplicate' => :duplicate)      
    end
  end
  
  describe "/re_plans/101/workflows/202/rules" do
    match_controller(:re_plan_workflow_rules, :re_plan_id => "101", :workflow_id => "202") do
      with_route(:get, '/re_plans/101/workflows/202/rules/new' => :new)
      with_route(:post, '/re_plans/101/workflows/202/rules' => :create)
  
      with_route(:get, '/re_plans/101/workflows/202/rules/help' => :help)
      with_route(:get, '/re_plans/101/workflows/202/rules/error' => :error)
    end
    match_controller(:re_plan_workflow_rules, :re_plan_id => "101", :workflow_id => "202", :id => "303") do  
      with_route(:get, '/re_plans/101/workflows/202/rules/303/edit' => :edit)
      with_route(:put, '/re_plans/101/workflows/202/rules/303' => :update)
      with_route(:delete, '/re_plans/101/workflows/202/rules/303' => :destroy)
  
      with_route(:put, '/re_plans/101/workflows/202/rules/303/move_up' => :move_up)
      with_route(:put, '/re_plans/101/workflows/202/rules/303/move_down' => :move_down)
    end
  end
  
  describe "/re_workflows" do
    match_controller(:re_workflows) do
      with_route(:get, '/re_workflows' => :index)
      with_route(:get, '/re_workflows/new' => :new)
      with_route(:post, '/re_workflows' => :create)
      with_route(:get, '/re_workflows/add' => :add)
    end
    
    match_controller(:re_workflows, :id => "101") do
      with_route(:get, '/re_workflows/101' => :show, 
                       '/re_workflows/101/edit' => :edit)
      with_route(:put, '/re_workflows/101' => :update)
      with_route(:delete, '/re_workflows/101' => :destroy)
    
      with_route(:get, '/re_workflows/101/plan' => :plan, 
                       '/re_workflows/101/change' => :change, 
                       '/re_workflows/101/preview' => :preview)
          
      with_route(:get, '/re_workflows/101/copy' => :copy)
      with_route(:post, '/re_workflows/101/duplicate' => :duplicate)
    end
  end    
  
  describe "/re_workflows/101/rules" do
    match_controller(:re_workflow_rules, :re_workflow_id => "101") do
      with_route(:get, '/re_workflows/101/rules/new' => :new)
      with_route(:post, '/re_workflows/101/rules' => :create)
  
      with_route(:get, '/re_workflows/101/rules/help' => :help)
      with_route(:get, '/re_workflows/101/rules/error' => :error)      
    end
    match_controller(:re_workflow_rules, :re_workflow_id => "101", :id => "202") do  
      with_route(:get, '/re_workflows/101/rules/202/edit' => :edit)
      with_route(:put, '/re_workflows/101/rules/202' => :update)
      with_route(:delete, '/re_workflows/101/rules/202' => :destroy)
  
      with_route(:put, '/re_workflows/101/rules/202/move_up' => :move_up)
      with_route(:put, '/re_workflows/101/rules/202/move_down' => :move_down)
    end
  end
  
  describe "/re_history" do
    match_controller(:re_history) do  
      with_route(:get, '/re_history' => :index)
    end 
    
    match_controller(:re_history, :id => "101") do  
      with_route(:get, '/re_history/101' => :show)
    end  
  end
  
  describe "/re_publications" do
    match_controller(:re_publications, :id => "101") do  
      with_route(:get, '/re_publications/101' => :show)
    end  
  end
end
