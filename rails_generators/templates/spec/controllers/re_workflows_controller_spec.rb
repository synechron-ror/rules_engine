require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReWorkflowsController do
  extend RulesEngineMacros
  
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
  end  

  describe "index" do
    it_should_require_rules_engine_reader_access(:index)
    
    it "should get the list of workflows" do
      re_workflows = [ReWorkflow.make(:title => 'a'), ReWorkflow.make(:title => 'b')]
      get :index
      assigns[:re_workflows].should == re_workflows
    end
  end
  
  describe "show" do
    it_should_require_rules_engine_reader_access(:show, :id => 123)
    
    it "should get the workflow record with the ID" do
      re_workflow = ReWorkflow.make
      get :show, :id => re_workflow.id
      assigns[:re_workflow].should == re_workflow
    end
  end
  
  describe "new" do
    it_should_require_rules_engine_editor_access(:new, :id => 123)
    
    it "should assign a new workflow record" do
      get :new
      assigns[:re_workflow].should be_instance_of(ReWorkflow)
    end
    
    it "should render the 'new' template" do
      get :new, :id => 123
      response.should render_template(:new)
    end
  end
    
  describe "create" do
    it_should_require_rules_engine_editor_access(:create, :re_workflow => {})
  
    before do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:new).and_return(@re_workflow) 
    end
    
    it "should assign the re_workflow parameters" do
      ReWorkflow.should_receive(:new).with("code" => "name", "title" => "value")
      post :create, :re_workflow => { :code => "name", :title => "value" }
    end
  
    it "should save the re_workflow" do
      @re_workflow.should_receive(:save)
      post :create, :re_workflow => { :title => "name" }
    end
        
    describe "save failed" do
      before(:each) do
        @re_workflow.stub!(:save).and_return(false)
      end
      
      it "should render the 'new' template" do
        post :create, :re_workflow => { :title => "name" }
        response.should render_template(:new)
      end
    end
  
    describe "save succeeded" do
      before(:each) do
        @re_workflow.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        post :create, :re_workflow => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_workflow page for HTML" do
        post :create, :re_workflow => { :title => "name" }
        response.should redirect_to(change_re_workflow_path(@re_workflow))
      end
  
      it "should render 'create' template for JAVASCRIPT" do
        xhr :post, :create, :re_workflow => { :title => "name" }
        response.should render_template(:create)
      end
    end
  end
    
  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit, :id => 123)
    
    it "should get the workflow record with the ID" do
      re_workflow = ReWorkflow.make
      get :edit, :id => re_workflow.id
      assigns[:re_workflow].should == re_workflow
    end
  end
  
  describe "update" do
    it_should_require_rules_engine_editor_access(:update, :id => 123, :re_workflow => {})
  
    before do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
    end
  
    it "should get the workflow record with the ID" do
      ReWorkflow.should_receive(:find).with("123").and_return(@re_workflow)
      put :update, :id => 123, :re_workflow => { :title => "value" }
      assigns[:re_workflow].should == @re_workflow
    end
    
    it "should assign the re_workflow parameters" do
      @re_workflow.should_receive(:attributes=).with("title" => "name")
      put :update, :id => 123, :re_workflow => { :title => "name" }
    end
  
    it "should not assign the re_workflow parameters :code" do
      @re_workflow.should_receive(:attributes=).with("title" => "name")
      put :update, :id => 123, :re_workflow => { :title => "name", :code => "code" }
    end
  
    it "should save the re_workflow" do
      @re_workflow.should_receive(:save)
      put :update, :id => 123, :re_workflow => { :title => "name" }
    end
        
    describe "save failed" do
      before(:each) do
        @re_workflow.stub!(:save).and_return(false)
      end
      
      it "should render the 'edit' template" do
        put :update, :id => 123, :re_workflow => { :title => "name" }
        response.should render_template(:edit)
      end
    end
  
    describe "save succeeded" do
      before do
        @re_workflow.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        put :update, :id => 123, :re_workflow => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_workflow page for HTML" do
        put :update, :id => 123, :re_workflow => { :title => "name" }
        response.should redirect_to(change_re_workflow_path(@re_workflow))
      end
  
      it "should render 'update' template for JAVASCRIPT" do
        xhr :put, :update, :id => 123, :re_workflow => { :title => "name" }
        response.should render_template(:update)
      end
    end
  end
  
  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy, :id => 123)
  
    before do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
    end
  
    it "should get the workflow record with the ID" do
      ReWorkflow.should_receive(:find).with("123").and_return(@re_workflow)
      delete :destroy, :id => 123
      assigns[:re_workflow].should == @re_workflow
    end
    
    it "should destroy the re_workflow" do
      @re_workflow.should_receive(:destroy)
      delete :destroy, :id => 123
    end
   
    it "should display a flash success message" do
      delete :destroy, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the re_workflows page for HTML" do
      delete :destroy, :id => 123
      response.should redirect_to(re_workflows_path)
    end
  
    it "should redirect to the re_workflows page for JAVASCRIPT" do
      xhr :delete, :destroy, :id => 123
      response.body.should == "window.location.href = '#{re_workflows_path}';"
    end    
  end
  
  describe "change" do
    it_should_require_rules_engine_editor_access(:change, :id => 123)
    
    before(:each) do
      @re_workflow = ReWorkflow.make
    end
    
    it "should rediscover all of the rules" do
      RulesEngine::Discovery.should_receive(:discover!)
      get :change, :id => @re_workflow.id
    end
        
    it "should get the workflow record with the ID" do
      get :change, :id => @re_workflow.id
      assigns[:re_workflow].should == @re_workflow
    end
  end
  
  describe "preview" do
    it_should_require_rules_engine_reader_access(:preview, :id => 123)
    
    it "should get the workflow record with the ID" do
      re_workflow = ReWorkflow.make
      ReWorkflow.should_receive(:find).with("123").and_return(re_workflow)
      get :preview, :id => 123
      assigns[:re_workflow].should == re_workflow
    end
  end
  
  describe "plan" do
    it_should_require_rules_engine_reader_access(:plan, :id => 123)
    
    it "should list the workflows" do
      re_workflow = ReWorkflow.make(:title => 'a')
      re_plan = RePlan.make
      re_plan.re_workflows = [re_workflow]

      get :plan, :id => re_workflow.id
      assigns[:re_plan_workflows].should == re_workflow.re_plan_workflows
    end       
  end
  
  describe "add" do
    it_should_require_rules_engine_reader_access(:add)
    
    it "should list the workflows to add to a workflow" do
      re_workflows = [ReWorkflow.make(:title => 'a'), ReWorkflow.make(:title => 'b')]
      get :add
      assigns[:re_workflows].should == re_workflows
    end       
  end
  
  describe "copy" do
    it_should_require_rules_engine_editor_access(:copy, :id => 123)
    
    before(:each) do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
    end
    
    it "should assign an empty workflow copy" do
      get :copy, :id => 1234  
      assigns[:re_workflow_copy].should be_instance_of(ReWorkflow)
    end        
  end
  
  describe "duplicate" do
    it_should_require_rules_engine_editor_access(:copy, :id => 123)
  
    before(:each) do
      @re_workflow = ReWorkflow.make
      ReWorkflow.stub!(:find).and_return(@re_workflow) 
      
      @re_workflow_copy = ReWorkflow.make
      ReWorkflow.should_receive(:new).and_return(@re_workflow_copy)      
    end
    
    it "should use the revert and publish method to copy the parameters" do
      @re_workflow.should_receive(:publish).and_return({:published => "mock value"})
      @re_workflow_copy.should_receive(:revert!).with({:published => "mock value"})      
      post :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
    end
    
    it "should update the attributes of the new workflow" do
      post :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
      @re_workflow_copy.title.should == 'new title'
    end
    
    describe "the copied workflow was saved" do
      before(:each) do
        @re_workflow_copy.stub!(:save).and_return(true)
      end  
      
      it "should display a flash success message" do
        post :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_workflow page for HTML" do
        post :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
        response.should redirect_to(change_re_workflow_path(@re_workflow_copy))
      end
  
      it "should redirect to the change re_workflows page for JAVASCRIPT" do
        xhr :post, :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
        response.body.should == "window.location.href = '#{change_re_workflow_path(@re_workflow_copy)}';"
      end    
    end    
    
    describe "the copied workflow was not saved" do
      before(:each) do
        @re_workflow_copy.stub!(:save).and_return(false)
      end  
  
      it "should render the 'copy' template" do
        post :duplicate, :id => 1234, :re_workflow => {:title => 'new title'}
        response.should render_template(:copy)
      end
    end
  end
end
