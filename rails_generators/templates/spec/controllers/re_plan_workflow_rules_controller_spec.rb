require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePlanWorkflowRulesController do
  extend RulesEngineMacros
  
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
    
    @re_plan = RePlan.make
    @re_workflow = ReWorkflow.make(:re_plans => [@re_plan])
    
    @rule_class = RulesEngine::Rule::Definition
    @rule_class.options = {
          :group => 'Mock',
          :display_name => 'Mock Rule',    
          :help_partial => '/mock_rule/help',
          :new_partial => '/mock_rule/new',
          :edit_partial => '/mock_rule/edit'
        }           
    
    RulesEngine::Discovery.stub!(:rule_class).and_return(@rule_class)        
  end  

  describe "help" do
    it_should_require_rules_engine_reader_access(:help, :re_plan_id => 123, :workflow_id => 456, :rule_class_name => 'mock_rule')
    
    before(:each) do
      controller.stub!(:render).with('/mock_rule/help')
    end
    
    describe "rule class exists" do
      it "should get the rule record with the rule_class_name" do
        get :help, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule'
        assigns[:re_plan].should == @re_plan
        assigns[:re_workflow].should == @re_workflow
        assigns[:rule_class].should == @rule_class
      end
      
      it "should render the help partial" do
        controller.should_receive(:render).with('/mock_rule/help')
        get :help, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule'
        response.should render_template(:help)
      end
    end        
    
    describe "rule class does not exist" do
      it "should render the error template" do
        RulesEngine::Discovery.stub!(:rule_class).and_return(nil)        
        get :help, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'unknown'
        response.should render_template(:error)
      end          
    end
  end

  describe "error" do
    it_should_require_rules_engine_reader_access(:error, :re_plan_id => 123, :workflow_id => 456)
    
    it "should render the error template" do
      get :error, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id
      response.should render_template(:error)
    end
  end
  
  describe "new" do
    it_should_require_rules_engine_editor_access(:new, :re_plan_id => 123, :workflow_id => 456)
    
    before(:each) do
      controller.stub!(:render).with('/mock_rule/new')
    end
    
    it "should assign a new rule record" do
      get :new, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id
      assigns[:re_rule].should be_instance_of(ReRule)
    end
    
    describe "the rule class exists" do
      it "should render the new partial" do
        controller.should_receive(:render).with('/mock_rule/new')
        get :new, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule'
        response.should render_template(:new)
      end      
    end
    
    describe "rule class does not exist" do
      it "should render the error template" do
        RulesEngine::Discovery.stub!(:rule_class).and_return(nil)        
        get :new, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'unknown'
        response.should render_template(:error)
      end          
    end
  end
    
  describe "create" do
    it_should_require_rules_engine_editor_access(:create, :re_plan_id => 123, :workflow_id => 456, :rule_class_name => 'mock_rule')
  
    before do
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
      ReRule.stub!(:new).and_return(@re_rule) 
    end
    
    it "should assign the re_rule" do
      ReRule.should_receive(:new).with(:re_workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule')
      post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
    end
  
    describe "rule class does not exist" do
      it "should render the error template" do
        @re_rule.stub!(:rule).and_return(nil)
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        response.should render_template(:error)
      end          
    end
    
    describe "rule class exists" do
      it "should assign the re_rule attributess" do
        @re_rule.should_receive(:rule_attributes=).with(hash_including(:rule_attibutes => 'mock attributes'))
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
      end
    end  
  
    describe "save failed" do
      before(:each) do
        @re_rule.stub!(:save).and_return(false)
      end
  
      it "should render the 'new' template" do
        controller.should_receive(:render).with('/mock_rule/new')
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        response.should render_template(:new)
      end      
    end
    
    describe "the rule is valid" do
      before(:each) do
        @re_rule.stub!(:valid?).and_return(true)
        @re_rule.stub!(:save).and_return(true)
      end
  
      it "should add the rule to the workflow" do
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        @re_workflow.re_rules.should include(@re_rule)
      end
            
      it "should display a flash success message" do
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_rule page for HTML" do
        post :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
      end
  
      it "should render 'update' template for JAVASCRIPT" do
        xhr :post, :create, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :rule_class_name => 'mock_rule', :rule_attibutes => 'mock attributes'
        response.should render_template(:update)
      end      
    end
  end
  
  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit, :re_plan_id => 123, :workflow_id => 456)
    
    before(:each) do
      controller.stub!(:render).with('/mock_rule/edit')
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
    end
    
    it "should assign a the rule record" do
      get :edit, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      assigns[:re_rule].should == @re_rule
    end
    
    describe "the rule class exists" do
      it "should render the edit partial" do
        controller.should_receive(:render).with('/mock_rule/edit')
        get :edit, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
        response.should render_template(:edit)
      end      
    end
    
    describe "rule class does not exist" do
      it "should render the error template" do
        RulesEngine::Discovery.stub!(:rule_class).and_return(nil)        
        get :edit, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
        response.should render_template(:error)
      end          
    end
  end
    
  describe "update" do
    it_should_require_rules_engine_editor_access(:update, :re_plan_id => 123, :workflow_id => 456, :id => 456, :rule_attibutes => 'mock attributes')
  
    before do
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
    end
  
    it "should get the rule record with the ID" do 
      ReRule.should_receive(:find).with("123").and_return(@re_rule)
      put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123, :rule_attibutes => 'mock attributes'
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule class does not exist" do
      it "should render the error template" do        
        ReRule.stub!(:find).and_return(@re_rule)
        @re_rule.stub!(:rule).and_return(nil)
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        response.should render_template(:error)
      end          
    end
    
    describe "rule class exists" do
      it "should assign the re_rule attributess" do
        ReRule.stub!(:find).and_return(@re_rule)
        @re_rule.should_receive(:rule_attributes=).with(hash_including(:rule_attibutes => 'mock attributes'))
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
      end
    end  
  
    describe "save failed" do
      before(:each) do
        ReRule.stub!(:find).and_return(@re_rule)
        @re_rule.stub!(:save).and_return(false)
      end
    
      it "should render the 'edit' template" do
        controller.should_receive(:render).with('/mock_rule/edit')
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        response.should render_template(:edit)
      end      
    end
    
    describe "the rule is valid" do
      it "should add the rule to the workflow" do
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        @re_workflow.re_rules.should include(@re_rule)
      end
            
      it "should display a flash success message" do
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_rule page for HTML" do
        put :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
      end
      
      it "should render 'update' template for JAVASCRIPT" do
        xhr :put, :update, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id, :rule_attibutes => 'mock attributes'
        response.should render_template(:update)
      end      
    end
  end
  
  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy, :re_plan_id => 123, :workflow_id => 456, :id => 456)
  
    before do
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
      ReRule.stub!(:find).and_return(@re_rule) 
    end
      
    it "should get the rule record with the ID" do
      ReRule.should_receive(:find).with("123").and_return(@re_rule)
      delete :destroy, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
      assigns[:re_rule].should == @re_rule
    end
    
    it "should destroy the re_rule" do
      @re_rule.should_receive(:destroy)
      delete :destroy, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
    end
       
    it "should display a flash success message" do
      delete :destroy, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_workflow page for HTML" do
      delete :destroy, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
      response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
    end
      
    it "should render the update template for JAVASCRIPT" do
      xhr :delete, :destroy, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
      response.should render_template(:update)
    end    
  end
  
  describe "move_up" do
    it_should_require_rules_engine_editor_access(:move_up, :re_plan_id => 123, :workflow_id => 456, :id => 456)
    
    before(:each) do
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
    end
    
    it "should get the rule record with the ID" do
      get :move_up, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      assigns[:re_workflow].should == @re_workflow
      assigns[:re_rule].should == @re_rule
    end
  
    it "should move the rule up" do
      ReRule.stub!(:find).and_return(@re_rule) 
      @re_rule.should_receive(:move_higher)
      put :move_up, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
    end
  
    it "should redirect to the change re_workflow page for HTML" do
      put :move_up, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
    end
      
    it "should render the update template for JAVASCRIPT" do
      xhr :put, :move_up, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      response.should render_template(:update)
    end    
  end
  
  describe "move_down" do
    it_should_require_rules_engine_editor_access(:move_down, :re_plan_id => 123, :workflow_id => 456, :id => 456)
    
    before(:each) do
      @re_rule = ReRule.make(:re_workflow => @re_workflow)
    end
    
    it "should get the rule record with the ID" do
      get :move_down, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      assigns[:re_workflow].should == @re_workflow
      assigns[:re_rule].should == @re_rule
    end
  
    it "should move the rule down" do
      ReRule.stub!(:find).and_return(@re_rule) 
      @re_rule.should_receive(:move_lower)
      put :move_down, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => 123
    end
  
    it "should redirect to the change re_workflow page for HTML" do
      put :move_down, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      response.should redirect_to(change_re_plan_workflow_path(@re_plan, @re_workflow))
    end
      
    it "should render the update template for JAVASCRIPT" do
      xhr :put, :move_down, :re_plan_id => @re_plan.id, :workflow_id => @re_workflow.id, :id => @re_rule.id
      response.should render_template(:update)
    end    
  end
end
