require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePlanWorkflowsController do
  extend RulesEngineMacros
  
  render_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
    
    @re_plan = RePlan.make
  end  

  describe "show" do
    it_should_require_rules_engine_reader_access(:show, :re_plan_id => 123, :id => 456)
    
    it "should get the workflow record with the ID" do
      re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
      get :show, :re_plan_id => @re_plan.id, :id => re_workflow.id
      assigns[:re_plan].should == @re_plan
      assigns[:re_workflow].should == re_workflow
    end
  end
  
  describe "new" do
    it_should_require_rules_engine_editor_access(:new, :re_plan_id => 123)
    
    it "should assign a new workflow record" do
      get :new, :re_plan_id => @re_plan.id
      assigns[:re_workflow].should be_instance_of(ReWorkflow)
    end
    
    it "should render the 'new' template" do
      get :new, :re_plan_id => @re_plan.id
      response.should render_template(:new)
    end
  end
    
  describe "create" do
    it_should_require_rules_engine_editor_access(:create, :re_plan_id => 123, :re_workflow => {})
  
    before do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:new).and_return(@re_workflow) 
    end
    
    it "should assign the re_workflow parameters" do
      ReWorkflow.should_receive(:new).with("code" => "name", "title" => "value")
      post :create, :re_plan_id => @re_plan.id, :re_workflow => { :code => "name", :title => "value" }
    end
  
    it "should save the re_workflow" do
      @re_workflow.should_receive(:save)
      post :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
    end
        
    describe "save failed" do
      before(:each) do
        @re_workflow.stub!(:save).and_return(false)
      end
      
      it "should render the 'new' template" do
        post :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
        response.should render_template(:new)
      end
    end
  
    describe "save succeeded" do
      before(:each) do
        @re_workflow.stub!(:save).and_return(true)
      end

      it "should add the workflow to the plan" do
        post :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
        @re_plan.re_workflows.should include(@re_workflow)
      end
            
      it "should display a flash success message" do
        post :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_workflow page for HTML" do
        post :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
        response.should redirect_to(change_re_plan_path(@re_plan))
      end
  
      it "should render 're_plans/update' template for JAVASCRIPT" do
        xhr :post, :create, :re_plan_id => @re_plan.id, :re_workflow => { :title => "name" }
        response.should render_template('re_plans/update')
      end
    end
  end

  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit, :re_plan_id => 123, :id => 456)
    
    it "should get the workflow record with the ID" do
      re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
      get :edit, :re_plan_id => @re_plan.id, :id => re_workflow.id
      assigns[:re_plan].should == @re_plan
      assigns[:re_workflow].should == re_workflow
    end
  end
  
  describe "update" do
    it_should_require_rules_engine_editor_access(:update, :re_plan_id => 123, :id => 456, :re_workflow => {})
  
    before do
      @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])      
    end
  
    it "should get the workflow record with the ID" do 
      ReWorkflow.should_receive(:find).with(123).and_return(@re_workflow)
      put :update, :re_plan_id => @re_plan.id, :id => 123, :re_workflow => { :title => "value" }      
      assigns[:re_workflow].should == @re_workflow
    end
    
    it "should assign the re_workflow parameters" do
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
      @re_workflow.should_receive(:attributes=).with("title" => "name")
      put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "name" }
    end
  
    it "should not assign the re_workflow parameters :code" do
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
      @re_workflow.should_receive(:attributes=).with("title" => "name")
      put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "name", :code => "code" }
    end
  
    it "should save the re_workflow" do
      put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "new name" }
      @re_workflow.reload
      @re_workflow.title.should == 'new name'
    end
        
    describe "save failed" do
      it "should render the 'edit' template" do
        put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => nil }
        response.should render_template(:edit)
      end
    end
  
    describe "save succeeded" do
      it "should display a flash success message" do
        put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_workflow page for HTML" do
        put :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "name" }
        response.should redirect_to(change_re_workflow_path(@re_workflow))
      end
  
      it "should render 'update' template for JAVASCRIPT" do        
        xhr :put, :update, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => { :title => "name" }
        response.should render_template(:update)
      end
    end
  end
  
  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy, :re_plan_id => 123, :id => 456)
  
    before do
      @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
    end
      
    it "should get the workflow record with the ID" do
      ReWorkflow.should_receive(:find).with(123).and_return(@re_workflow)
      delete :destroy, :re_plan_id => @re_plan.id, :id => 123
      assigns[:re_workflow].should == @re_workflow
    end
    
    it "should destroy the re_workflow" do
      @re_workflow.should_receive(:destroy)
      delete :destroy, :re_plan_id => @re_plan.id, :id => 123
    end
       
    it "should display a flash success message" do
      delete :destroy, :re_plan_id => @re_plan.id, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_plan page for HTML" do
      delete :destroy, :re_plan_id => @re_plan.id, :id => 123
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
      
    it "should redirect to the change re_plan page page for JAVASCRIPT" do
      xhr :delete, :destroy, :re_plan_id => @re_plan.id, :id => 123
      response.body.should == "window.location.href = '#{change_re_plan_path(@re_plan)}';"
    end    
  end
  
  describe "change" do
    it_should_require_rules_engine_editor_access(:change, :re_plan_id => 123, :id => 456)
    
    before(:each) do
      @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
    end
    
    it "should rediscover all of the rules" do
      RulesEngine::Discovery.should_receive(:discover!)
      get :change, :re_plan_id => @re_plan.id, :id => @re_workflow.id
    end
        
    it "should get the workflow record with the ID" do
      get :change, :re_plan_id => @re_plan.id, :id => @re_workflow.id
      assigns[:re_plan].should == @re_plan
      assigns[:re_workflow].should == @re_workflow
    end
  end
  
  describe "default" do
    it_should_require_rules_engine_editor_access(:default, :re_plan_id => 123, :id => 456)
    
    before(:each) do
      @re_workflow_one = ReWorkflow.make(:re_plans => [@re_plan])
      @re_workflow_two = ReWorkflow.make(:re_plans => [@re_plan])
    end
        
    it "should set the default workflow" do
      @re_plan.default_workflow.should == @re_workflow_one
      put :default, :re_plan_id => @re_plan.id, :id => @re_workflow_two.id
      @re_plan.reload
      @re_plan.default_workflow.should == @re_workflow_two
    end
            
    it "should redirect to the change re_plan page for HTML" do
      put :default, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
      
    it "should render to the update re_plan page page for JAVASCRIPT" do
      xhr :put, :default, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should render_template('re_plans/update')
    end    
  end
  
  describe "add" do
    it_should_require_rules_engine_editor_access(:add, :re_plan_id => 123, :id => 456)

    before(:each) do
      @re_workflow_one = ReWorkflow.make(:re_plans => [@re_plan])
      @re_workflow_two = ReWorkflow.make
    end
        
    it "should add the workflow" do
      put :add, :re_plan_id => @re_plan.id, :id => @re_workflow_two.id
      @re_plan.reload
      @re_plan.re_workflows.should == [@re_workflow_one, @re_workflow_two]
    end

    it "should redirect to the change re_plan page for HTML" do
      put :add, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
      
    it "should render to the update re_plan page page for JAVASCRIPT" do
      xhr :put, :add, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should render_template('re_plans/update')
    end    
  end

  describe "remove" do
    it_should_require_rules_engine_editor_access(:remove, :re_plan_id => 123, :id => 456)

    before(:each) do
      @re_workflow_one = ReWorkflow.make(:re_plans => [@re_plan])
      @re_workflow_two = ReWorkflow.make(:re_plans => [@re_plan])
    end
        
    it "should remove the workflow" do
      put :remove, :re_plan_id => @re_plan.id, :id => @re_workflow_two.id
      @re_plan.reload
      @re_plan.re_workflows.should == [@re_workflow_one]
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_plan page for HTML" do
      put :remove, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
      
    it "should render to the update re_plan page page for JAVASCRIPT" do
      xhr :put, :remove, :re_plan_id => @re_plan.id, :id => @re_workflow_one.id
      response.should render_template('re_plans/update')
    end    
  end
  
  describe "copy" do
    it_should_require_rules_engine_editor_access(:copy, :re_plan_id => 123, :id => 456)

    before(:each) do
      @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
    end
    
    it "should assign an empty workflow copy" do
      get :copy, :re_plan_id => @re_plan.id, :id => @re_workflow.id
      assigns[:re_workflow_copy].should be_instance_of(ReWorkflow)
    end        
  end
  
  describe "duplicate" do
    it_should_require_rules_engine_editor_access(:duplicate, :re_plan_id => 123, :id => 456)
  
    before(:each) do
      @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
      
      @re_workflow_copy = ReWorkflow.make
      ReWorkflow.stub!(:new).and_return(@re_workflow_copy)      
    end
    
    it "should use the revert and publish method to copy the parameters" do
      @re_workflow.should_receive(:publish).and_return({:published => "mock value"})
      @re_workflow_copy.should_receive(:revert!).with({:published => "mock value"})      
      post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}
    end
    
    it "should update the attributes of the new workflow" do
      post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}
      @re_workflow_copy.title.should == 'new title'
    end
    
    describe "the copied workflow was saved" do
      before(:each) do
        @re_workflow_copy.stub!(:save).and_return(true)
      end  

      it "should add the copied workflow to the re_plan" do
        RePlan.stub!(:find).and_return(@re_plan) 
        @re_plan.should_receive(:add_workflow).with(@re_workflow_copy)
        post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}        
      end      
      
      it "should display a flash success message" do
        post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_plan workflow page for HTML" do
        post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}
        response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow_copy))
      end
  
      it "should redirect to the change re_workflows page for JAVASCRIPT" do
        xhr :post, :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => 'new title'}
        response.body.should == "window.location.href = '#{change_re_plan_workflow_path(@re_plan, @re_workflow_copy)}';"
      end    
    end    
    
    describe "the copied workflow was not saved" do
      it "should render the 'copy' template" do
        post :duplicate, :re_plan_id => @re_plan.id, :id => @re_workflow.id, :re_workflow => {:title => nil}
        response.should render_template(:copy)
      end
    end
  end
end
