require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRulesController do
  extend RulesEngineMacros
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
    
    @rule = mock("Rule", :valid? => true)
    
    @re_pipeline = mock_model(RePipeline)
    RePipeline.stub!(:find).and_return(@re_pipeline)    
    
    @re_rule = mock_model(ReRule, :re_pipeline_id => @re_pipeline.id)
    @re_rule.stub!(:rule).and_return(@rule)    
    ReRule.stub!(:new).and_return(@re_rule)
    ReRule.stub!(:find).and_return(@re_rule)
  end  

  describe "help" do
    it_should_require_rules_engine_reader_access(:help)
    
    before(:each) do
      @rule_class = mock("RuleClass")
      RulesEngine::Discovery.stub!(:rule_class).and_return(@rule_class)
      @rule_class.stub!(:new).and_return(@rule)      
    end
    
    it "should assign the re_pipeline" do
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load discover the rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class").and_return(@rule_class)
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
    end

    describe "rule class not found" do
      it "should render the 'error' template" do
        RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class").and_return(nil)
        get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
        response.should render_template(:error)
      end
    end  
    
    describe "rule class found" do        
      it "should assign the rule_class" do
        get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
        assigns[:rule_class].should == @rule_class
      end      

      it "should assign the rule" do
        get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
        assigns[:rule].should == @rule
      end      
    end  
  end

  describe "error" do
    it_should_require_rules_engine_reader_access(:error)
  
    it "should assign the re_pipeline" do
      get :error, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_pipeline].should == @re_pipeline
    end      
  end
  
  describe "new" do
    it_should_require_rules_engine_editor_access(:new)
  
    it "should assign the re_pipeline" do
      get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign a new re_rule record" do
      ReRule.should_receive(:new).and_return(@re_rule)
      get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule class not found" do
      it "should render the 'error' template" do
        @re_rule.should_receive(:rule).and_return(nil)
        get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
        response.should render_template(:error)
      end
    end  
        
    describe "rule class found" do
      it "should render the 'new' template" do
        get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
        response.should render_template(:new)
      end
    end    
  end
  
  describe "create" do
    
    before(:each) do
      @re_rule.stub!(:rule_attributes=)
      @re_rule.stub!(:valid?).and_return(true)      
      @re_rule.stub!(:save).and_return(true)      
    end
    
    it_should_require_rules_engine_editor_access(:create)
  
    it "should assign the re_pipeline" do
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign the new re_rule record with the re_pipeline id" do
      ReRule.should_receive(:new).with(hash_including(:re_pipeline_id => @re_pipeline.id)).and_return(@re_rule)
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
    
    it "should assign the new re_rule record with the rule class name" do
      ReRule.should_receive(:new).with(hash_including(:rule_class_name => "mock_rule_class")).and_return(@re_rule)
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule class not found" do
      it "should render the 'error' template" do
        @re_rule.should_receive(:rule).and_return(nil)
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
        response.should render_template(:error)
      end
    end  

    describe "rule class found" do
      it "should assign the rule attributes" do
        @re_rule.should_receive(:rule_attributes=).with(hash_including("re_pipeline" => "1001", "rule_class_name" => "mock_rule_class", "re_rule" => { "key" => "value" }))
        post :create, :re_pipeline => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      end
      
      describe "re_rule invalid" do
        it "should render the 'new' template" do
          @re_rule.should_receive(:valid?).and_return(false)
          post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
          response.should render_template(:new)
        end
      end
      
      describe "re_rule cannot be saved" do
        it "should render the 'new' template" do
          @re_rule.should_receive(:save).and_return(false)
          post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
          response.should render_template(:new)
        end
      end
      
      describe "re_rule valid and saved" do
        it "should set the success message" do
          post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
          flash[:success].should_not be_blank
        end
      
        it "should redirect to the change re_pipeline page for HTML" do
          post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
          response.should redirect_to(change_re_pipeline_path(@re_pipeline))
        end
      
        it "should render 'update' template for JAVASCRIPT" do
          xhr :post, :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
          response.should render_template(:update)
        end
      end
    end  
  end
    
  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit)
  
    it "should assign the re_pipeline" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign a new re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule class not found" do
      it "should render the 'error' template" do
        @re_rule.should_receive(:rule).and_return(nil)
        get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
        response.should render_template(:error)
      end
    end  

    it "should render the 'edit' template" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should render_template(:edit)
    end
  end

  describe "update" do
    before(:each) do
      @re_rule.stub!(:rule_attributes=)
      @re_rule.stub!(:valid?).and_return(true)      
      @re_rule.stub!(:save).and_return(true)      
    end

    it_should_require_rules_engine_editor_access(:update)
  
    it "should assign the re_pipeline" do
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule class not found" do
      it "should render the 'error' template" do
        @re_rule.should_receive(:rule).and_return(nil)
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
        response.should render_template(:error)
      end
    end  

    describe "rule class found" do
      it "should assign the rule attributes" do
        @re_rule.should_receive(:rule_attributes=).with(hash_including("re_pipeline_id" => "1001", "re_rule_id" => "2002", "re_rule" => { "key" => "value" }))
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      end
      
      describe "re_rule invalid" do
        it "should render the 'edit' template" do
          @re_rule.should_receive(:valid?).and_return(false)
          put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
          response.should render_template(:edit)
        end
      end
      
      describe "re_rule cannot be saved" do
        it "should render the 'new' template" do
          @re_rule.should_receive(:save).and_return(false)
          put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
          response.should render_template(:edit)
        end
      end
      
      describe "re_rule valid and saved" do
        it "should set the success message" do
          put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
          flash[:success].should_not be_blank
        end
      
        it "should redirect to the change re_pipeline page for HTML" do
          put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
          response.should redirect_to(change_re_pipeline_path(@re_pipeline))
        end
      
        it "should render 'update' template for JAVASCRIPT" do
          xhr :put, :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
          response.should render_template(:update)
        end            
      end
    end  
  end
  
  describe "destroy" do
    before(:each) do
      @re_rule.stub!(:destroy).and_return(true)      
    end
    
    it_should_require_rules_engine_editor_access(:destroy)
  
    it "should assign the re_pipeline" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end

    it "should destroy the re_rule" do
      @re_rule.should_receive(:destroy)
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should set the success message" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      flash[:success].should_not be_blank
    end

    it "should redirect to the change re_pipeline page for HTML" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'destroy' template for JAVASCRIPT" do
      xhr :delete, :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should render_template(:destroy)
    end          
  end
  
  describe "move_up" do
    before(:each) do
      @re_rule.stub!(:move_higher).and_return(true)      
    end
    
    it_should_require_rules_engine_editor_access(:move_up)
  
    it "should assign the re_pipeline" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end

    it "should call move_higher for the re_rule" do
      @re_rule.should_receive(:move_higher)
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should set the success message" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      flash[:success].should_not be_blank
    end

    it "should redirect to the change re_pipeline page for HTML" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should render_template(:update)
    end          
  end

  describe "move_down" do
    before(:each) do
      @re_rule.stub!(:move_lower).and_return(true)      
    end
    
    it_should_require_rules_engine_editor_access(:move_down)
  
    it "should assign the re_pipeline" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end

    it "should call move_lower for the re_rule" do
      @re_rule.should_receive(:move_lower)
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should set the success message" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      flash[:success].should_not be_blank
    end

    it "should redirect to the change re_pipeline page for HTML" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should render_template(:update)
    end          
  end
end