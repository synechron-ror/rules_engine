require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePlansController do
  extend RulesEngineMacros
  
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
  end  

  describe "index" do
    it_should_require_rules_engine_reader_access(:index)
    
    it "should get the list of plans" do
      re_plans = [RePlan.make(:draft, :title => 'a'), RePlan.make(:changed, :title => 'b'), RePlan.make(:published, :title => 'c')]
      get :index
      assigns[:re_plans].should == re_plans
    end
  end
  
  describe "show" do
    it_should_require_rules_engine_reader_access(:show, :id => 123)
    
    it "should get the plan record with the ID" do
      re_plan = RePlan.make
      get :show, :id => re_plan.id
      assigns[:re_plan].should == re_plan
    end
  end
  
  describe "new" do
    it_should_require_rules_engine_editor_access(:new, :id => 123)
    
    it "should assign a new plan record" do
      re_plan = RePlan.make
      RePlan.should_receive(:new).and_return(re_plan)
      get :new, :id => 123
      assigns[:re_plan].should == re_plan
    end
    
    it "should render the 'new' template" do
      get :new, :id => 123
      response.should render_template(:new)
    end
  end
    
  describe "create" do
    it_should_require_rules_engine_editor_access(:create, :re_plan => {})
  
    before do
      @re_plan = RePlan.make
      RePlan.stub!(:new).and_return(@re_plan) 
    end
    
    it "should assign the re_plan parameters" do
      RePlan.should_receive(:new).with("code" => "name", "title" => "value")
      post :create, :re_plan => { :code => "name", :title => "value" }
    end
  
    it "should save the re_plan" do
      @re_plan.should_receive(:save)
      post :create, :re_plan => { :title => "name" }
    end
        
    describe "save failed" do
      before(:each) do
        @re_plan.stub!(:save).and_return(false)
      end
      
      it "should render the 'new' template" do
        post :create, :re_plan => { :title => "name" }
        response.should render_template(:new)
      end
    end
  
    describe "save succeeded" do
      before(:each) do
        @re_plan.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        post :create, :re_plan => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_plan page for HTML" do
        post :create, :re_plan => { :title => "name" }
        response.should redirect_to(change_re_plan_path(@re_plan))
      end
  
      it "should render 'create' template for JAVASCRIPT" do
        xhr :post, :create, :re_plan => { :title => "name" }
        response.should render_template(:create)
      end
    end
  end
    
  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit, :id => 123)
    
    it "should get the plan record with the ID" do
      re_plan = RePlan.make
      RePlan.should_receive(:find).with("123").and_return(re_plan)
      get :edit, :id => 123
      assigns[:re_plan].should == re_plan
    end
  end
  
  describe "update" do
    it_should_require_rules_engine_editor_access(:update, :id => 123, :re_plan => {})
  
    before do
      @re_plan = RePlan.make
      RePlan.stub!(:find).and_return(@re_plan) 
    end
  
    it "should get the plan record with the ID" do
      RePlan.should_receive(:find).with("123").and_return(@re_plan)
      put :update, :id => 123, :re_plan => { :title => "value" }
      assigns[:re_plan].should == @re_plan
    end
    
    it "should assign the re_plan parameters" do
      @re_plan.should_receive(:attributes=).with("title" => "name")
      put :update, :id => 123, :re_plan => { :title => "name" }
    end
  
    it "should not assign the re_plan parameters :code" do
      @re_plan.should_receive(:attributes=).with("title" => "name")
      put :update, :id => 123, :re_plan => { :title => "name", :code => "code" }
    end
  
    it "should save the re_plan" do
      @re_plan.should_receive(:save)
      put :update, :id => 123, :re_plan => { :title => "name" }
    end
        
    describe "save failed" do
      before(:each) do
        @re_plan.stub!(:save).and_return(false)
      end
      
      it "should render the 'edit' template" do
        put :update, :id => 123, :re_plan => { :title => "name" }
        response.should render_template(:edit)
      end
    end
  
    describe "save succeeded" do
      before do
        @re_plan.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        put :update, :id => 123, :re_plan => { :title => "name" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_plan page for HTML" do
        put :update, :id => 123, :re_plan => { :title => "name" }
        response.should redirect_to(change_re_plan_path(@re_plan))
      end
  
      it "should render 'update' template for JAVASCRIPT" do
        xhr :put, :update, :id => 123, :re_plan => { :title => "name" }
        response.should render_template(:update)
      end
    end
  end
  
  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy, :id => 123)
  
    before do
      @re_plan = RePlan.make
      RePlan.stub!(:find).and_return(@re_plan) 
    end
  
    it "should get the plan record with the ID" do
      RePlan.should_receive(:find).with("123").and_return(@re_plan)
      delete :destroy, :id => 123
      assigns[:re_plan].should == @re_plan
    end
    
    it "should destroy the re_plan" do
      @re_plan.should_receive(:destroy)
      delete :destroy, :id => 123
    end
   
    it "should display a flash success message" do
      delete :destroy, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the re_plans page for HTML" do
      delete :destroy, :id => 123
      response.should redirect_to(re_plans_path)
    end
  
    it "should redirect to the re_plans page for JAVASCRIPT" do
      xhr :delete, :destroy, :id => 123
      response.body.should == "window.location.href = '#{re_plans_path}';"
    end    
  end
  
  describe "change" do
    it_should_require_rules_engine_editor_access(:change, :id => 123)
    
    it "should get the plan record with the ID" do
      re_plan = RePlan.make
      RePlan.should_receive(:find).with("123").and_return(re_plan)
      get :change, :id => 123
      assigns[:re_plan].should == re_plan
    end
  end
  
  describe "preview" do
    it_should_require_rules_engine_reader_access(:preview, :id => 123)
    
    it "should get the plan record with the ID" do
      re_plan = RePlan.make
      RePlan.should_receive(:find).with("123").and_return(re_plan)
      get :preview, :id => 123
      assigns[:re_plan].should == re_plan
    end
  end
  
  describe "publish" do
    it_should_require_rules_engine_editor_access(:publish, :id => 123)

    before do
      @re_plan = RePlan.make
      @re_plan.stub!(:plan_error).and_return(nil)
      RePlan.stub!(:find).and_return(@re_plan) 
    end
    
    describe "tag is blank" do
      it "should display a flash error message" do
        put :publish, :id => 123, :tag => ""
        flash[:error].should_not be_blank
      end
    end

    describe "plan is valid" do
      before(:each) do
        @publisher = mock('publisher')
        @publisher.stub!(:publish)
        RulesEngine::Publish.stub!(:publisher).and_return(@publisher)
      end
      
      it "should publish the plan" do
        @publisher.should_receive(:publish).with(@re_plan.code, "publish tag", @re_plan.publish)
        put :publish, :id => 123, :tag => "publish tag"
      end

      it "should update the plan to published" do
        put :publish, :id => 123, :tag => "publish tag"
        @re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
      end

      it "should display a flash success message" do
        put :publish, :id => 123, :tag => "publish tag"
        flash[:success].should_not be_blank
      end
    end
    
    it "should redirect to the change_re_plan page for HTML" do
      put :publish, :id => 123, :tag => "publish tag"
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
  
    it "should render the update page for JAVASCRIPT" do
      xhr :put, :publish, :id => 123, :tag => "publish tag"
      response.should render_template(:update)
    end    
  end
  
  describe "revert" do
    it_should_require_rules_engine_editor_access(:revert, :id => 123)
  
    before do
      @publisher = mock('publisher')
      @publisher.stub!(:get)
      RulesEngine::Publish.stub!(:publisher).and_return(@publisher)
      
      @re_plan = RePlan.make
      RePlan.stub!(:find).and_return(@re_plan) 
    end
  
    it "should get the plan record with the ID" do
      RePlan.should_receive(:find).with("123").and_return(@re_plan)
      put :revert, :id => 123
      assigns[:re_plan].should == @re_plan
    end
    
    it "should get the plan from the publisher" do
      @publisher.should_receive(:get).with(@re_plan.code)
      put :revert, :id => 123
    end
        
    describe "the publisher does not have the plan" do
      it "should set an error message" do
        put :revert, :id => 123
        flash[:error].should_not be_blank
      end          
    end
    
    describe "the publisher has the plan" do
      before(:each) do
        @plan = {:code => 'mock plan'}
        @publisher.stub!(:get).and_return(@plan)
        @publisher.stub!(:revert!)
        @re_plan.stub!(:save!)
      end
      
      it "should revert the plan" do
        @re_plan.should_receive(:revert!).with(@plan)
        put :revert, :id => 123
      end

      it "should save the plan" do
        @re_plan.should_receive(:save!)
        put :revert, :id => 123
      end
          
      it "should display a flash success message" do
        put :revert, :id => 123
        flash[:success].should_not be_blank
      end
    end
    
    it "should redirect to the change re_plan page for HTML" do
      put :revert, :id => 123
      response.should redirect_to(change_re_plan_path(@re_plan))
    end
  
    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :revert, :id => 123
      response.should render_template(:update)
    end    
  end
  
  describe "history" do
    it_should_require_rules_engine_reader_access(:history, :id => 123)
    
    it "should get the process runner history from the rules engine process runner" do
      re_plan = RePlan.make(:code => "mock_code")
      
      runner = mock('runner')
      RulesEngine::Process.stub!(:runner).and_return(runner)
      
      re_history = {:history => "none"}
      runner.should_receive(:history).with("mock_code", anything()).and_return(re_history)
      get :history, :id => re_plan.id
      assigns[:re_history].should == re_history
    end        
  end

  describe "copy" do
    it_should_require_rules_engine_editor_access(:copy, :id => 123)
    
    before(:each) do
      @re_plan = RePlan.make
      RePlan.stub!(:find).and_return(@re_plan) 
    end
    
    it "should assign an empty plan copy" do
      get :copy, :id => 1234  
      assigns[:re_plan_copy].should be_instance_of(RePlan)
    end        
  end
  
  describe "duplicate" do
    it_should_require_rules_engine_editor_access(:copy, :id => 123)

    before(:each) do
      @re_plan = RePlan.make
      RePlan.stub!(:find).and_return(@re_plan) 
      
      @re_plan_copy = RePlan.make
      RePlan.should_receive(:new).and_return(@re_plan_copy)      
    end
    
    it "should use the revert and publish method to copy the parameters" do
      @re_plan.should_receive(:publish).and_return({:published => "mock value"})
      @re_plan_copy.should_receive(:revert!).with({:published => "mock value"})      
      post :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
    end
    
    it "should update the attributes of the new plan" do
      post :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
      @re_plan_copy.title.should == 'new title'
    end
    
    describe "the copied plan was saved" do
      before(:each) do
        @re_plan_copy.stub!(:save).and_return(true)
      end  
      
      it "should display a flash success message" do
        post :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_plan page for HTML" do
        post :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
        response.should redirect_to(change_re_plan_path(@re_plan_copy))
      end
  
      it "should redirect to the change re_plans page for JAVASCRIPT" do
        xhr :post, :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
        response.body.should == "window.location.href = '#{change_re_plan_path(@re_plan_copy)}';"
      end    
    end    
    
    describe "the copied plan was not saved" do
      before(:each) do
        @re_plan_copy.stub!(:save).and_return(false)
      end  

      it "should render the 'copy' template" do
        post :duplicate, :id => 1234, :re_plan => {:title => 'new title'}
        response.should render_template(:copy)
      end
    end
  end
end
