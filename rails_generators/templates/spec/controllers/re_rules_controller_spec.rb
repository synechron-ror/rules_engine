require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRulesController do
  extend RulesEngineMacros
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
    
    @mock_rule_class = mock("RuleClass")
    RulesEngine::Discovery.stub!(:rule_class).and_return(@mock_rule_class)
    @mock_rule = mock("Rule", :valid? => true, :attributes= => true, :save => true, :load => true, :after_create => true, :after_update => true, :before_destroy => true)
    @mock_rule_class.stub!(:new).and_return(@mock_rule)
    
    @re_pipeline = mock_model(RePipeline)
    RePipeline.stub!(:find).and_return(@re_pipeline)    
    
    @re_rule = mock_model(ReRule, :save => true, :destroy => true, :rule_class_name => "re_rule_rule_class", :re_pipeline_id => @re_pipeline.id, :move_higher => true, :move_lower => true)
    ReRule.stub!(:new).and_return(@re_rule)
    ReRule.stub!(:find).and_return(@re_rule)
  end  

  describe "help" do
    it_should_require_rules_engine_reader_access(:help)

    it "should assign the re_pipeline" do
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule_class_name" do
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class").and_return(@mock_rule_class)
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
    end
    
    it "should assign the rule_class" do
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:rule_class].should == @mock_rule_class
    end      

    it "should assign the rule" do
      get :help, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:rule].should == @mock_rule
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
    
    it "should call load_rule_class_from_rule_class_name" do
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class").and_return(@mock_rule_class)
      get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
    end
    
    it "should assign the rule_class" do
      get :new, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      get :new, :re_pipeline => 1001, :rule_class_name => "mock_rule_class"
      assigns[:rule].should == @mock_rule
    end      
    
    it "should assign a new re_rule record" do
      ReRule.should_receive(:new).and_return(@re_rule)
      get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
      assigns[:re_rule].should == @re_rule
    end
    
    it "should render the 'new' template" do
      get :new, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class"
      response.should render_template(:new)
    end
  end
  
  describe "create" do
    it_should_require_rules_engine_editor_access(:create)
  
    it "should assign the re_pipeline" do
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule_class_name" do
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class").and_return(@mock_rule_class)
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
    end
    
    it "should assign the rule_class" do
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:rule].should == @mock_rule
    end      
    
    it "should assign the new re_rule record with the re_pipeline id" do
      ReRule.should_receive(:new).with(hash_including(:re_pipeline_id => @re_pipeline.id)).and_return(@re_rule)
      post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end

    it "should assign the rule attributes" do
      @mock_rule.should_receive(:attributes=).with(hash_including("re_pipeline" => "1001", "rule_class_name" => "mock_rule_class", "re_rule" => { "key" => "value" }))
      post :create, :re_pipeline => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
    
    describe "rule invalid" do
      it "should render the 'new' template" do
        @mock_rule.stub!(:valid?).and_return(false)
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
        response.should render_template(:new)
      end
    end

    describe "rule cannot be saved" do
      it "should render the 'new' template" do
        @mock_rule.stub!(:save).and_return(false)
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
        response.should render_template(:new)
      end
    end

    describe "re_rule cannot be saved" do
      it "should render the 'new' template" do
        @mock_rule.stub!(:save).and_return(false)
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
        response.should render_template(:new)
      end
    end

    describe "rule and re_rule valid and saved" do
      it "should set the success message" do
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
        flash[:success].should_not be_blank
      end

      it "should call after_create for the rule" do
        @mock_rule.should_receive(:after_create).with(@re_rule)
        post :create, :re_pipeline_id => 1001, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }        
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
    
  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit)
  
    it "should assign the re_pipeline" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("re_rule_rule_class").and_return(@mock_rule_class)
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should assign the rule_class" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule].should == @mock_rule
    end      
    
    it "should assign a new re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end
    
    it "should render the 'edit' template" do
      get :edit, :re_pipeline_id => 1001, :re_rule_id => 2002
      response.should render_template(:edit)
    end
  end

  describe "update" do
    it_should_require_rules_engine_editor_access(:update)
  
    it "should assign the re_pipeline" do
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("re_rule_rule_class").and_return(@mock_rule_class)
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
    end
    
    it "should assign the rule_class" do
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:rule].should == @mock_rule
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
    
    it "should assign the rule attributes" do
      @mock_rule.should_receive(:attributes=).with(hash_including("re_pipeline" => "1001", "re_rule_id" => "2002", "rule_class_name" => "mock_rule_class", "re_rule" => { "key" => "value" }))
      put :update, :re_pipeline => 1001, :re_rule_id => 2002, :rule_class_name => "mock_rule_class", :re_rule => { :key => "value" }
      assigns[:re_rule].should == @re_rule
    end
   
    describe "rule invalid" do
      it "should render the 'edit' template" do
        @mock_rule.stub!(:valid?).and_return(false)
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
        response.should render_template(:edit)
      end
    end

    describe "rule cannot be saved" do
      it "should render the 'edit' template" do
        @mock_rule.stub!(:save).and_return(false)
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
        response.should render_template(:edit)
      end
    end

    describe "re_rule cannot be saved" do
      it "should render the 'edit' template" do
        @mock_rule.stub!(:save).and_return(false)
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
        response.should render_template(:edit)
      end
    end

    describe "rule and re_rule valid and saved" do
      it "should set the success message" do
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }
        flash[:success].should_not be_blank
      end

      it "should call after_update for the rule" do
        @mock_rule.should_receive(:after_update).with(@re_rule)
        put :update, :re_pipeline_id => 1001, :re_rule_id => 2002, :re_rule => { :key => "value" }        
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
  
  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy)
  
    it "should assign the re_pipeline" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("re_rule_rule_class").and_return(@mock_rule_class)
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should assign the rule_class" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule].should == @mock_rule
    end      
    
    it "should assign the re_rule record" do
      ReRule.should_receive(:find).and_return(@re_rule)
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_rule].should == @re_rule
    end

    it "should call before_update for the rule" do
      @mock_rule.should_receive(:before_destroy).with(@re_rule)
      delete :destroy, :re_pipeline_id => 1001, :re_rule_id => 2002
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
    it_should_require_rules_engine_editor_access(:move_up)
  
    it "should assign the re_pipeline" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("re_rule_rule_class").and_return(@mock_rule_class)
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should assign the rule_class" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      put :move_up, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule].should == @mock_rule
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
    it_should_require_rules_engine_editor_access(:move_down)
  
    it "should assign the re_pipeline" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:re_pipeline].should == @re_pipeline
    end      
    
    it "should call load_rule_class_from_rule" do
      RulesEngine::Discovery.should_receive(:rule_class).with("re_rule_rule_class").and_return(@mock_rule_class)
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
    end
    
    it "should assign the rule_class" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule_class].should == @mock_rule_class
    end      
  
    it "should assign the rule" do
      put :move_down, :re_pipeline_id => 1001, :re_rule_id => 2002
      assigns[:rule].should == @mock_rule
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
  
  describe "load_rule_class_from_rule_class_name" do
    before(:each) do
      @mock_flash = {}
      controller.stub!(:flash).and_return(@mock_flash)
      controller.stub!(:render)
    end
    
    it "should use the rule_class_name parameter to load the class" do
      controller.stub!(:params).and_return(:rule_class_name => "mock_rule_class")
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class")      
      controller.send(:load_rule_class_from_rule_class_name)
    end              
    
    describe "rule_class not found" do
      before(:each) do
        RulesEngine::Discovery.stub!(:rule_class).and_return(nil)
      end
      
      it "should set the flash error message" do
        controller.send(:load_rule_class_from_rule_class_name)
        @mock_flash[:error].should_not be_blank
      end
      
      it "should render the 'error' template" do
        controller.should_receive(:render).with(:error)
        controller.send(:load_rule_class_from_rule_class_name)        
      end                    
    end
        
    describe "rule_class found" do
      it "should assign the rule_class and rule" do    
        controller.send(:load_rule_class_from_rule_class_name)  
        controller.instance_variable_get(:@rule_class).should == @mock_rule_class
        controller.instance_variable_get(:@rule).should == @mock_rule
      end          
    end
  end


  describe "load_rule_class_from_model" do
    before(:each) do
      controller.instance_variable_set(:@re_rule, @re_rule)
      @mock_flash = {}
      controller.stub!(:flash).and_return(@mock_flash)
      controller.stub!(:render)
    end
    
    it "should use the rule_class_name variable to load the class" do
      @re_rule.should_receive(:rule_class_name).and_return("mock_rule_class")
      RulesEngine::Discovery.should_receive(:rule_class).with("mock_rule_class")
      controller.send(:load_rule_class_from_model)
    end              
    
    describe "rule_class not found" do
      before(:each) do
        RulesEngine::Discovery.stub!(:rule_class).and_return(nil)
      end
      
      it "should set the flash error message" do
        controller.send(:load_rule_class_from_model)
        @mock_flash[:error].should_not be_blank
      end
      
      it "should render the 'error' template" do
        controller.should_receive(:render).with(:error)
        controller.send(:load_rule_class_from_model)        
      end                    
    end
        
    describe "rule_class found" do
      it "should assign the rule_class and rule" do    
        controller.send(:load_rule_class_from_model)  
        controller.instance_variable_get(:@rule_class).should == @mock_rule_class
        controller.instance_variable_get(:@rule).should == @mock_rule
      end          
      
      describe "the rule cannot be loaded" do
        it "should render the 'error' template" do
          @mock_rule.should_receive(:load).with(@re_rule).and_return(false)
          controller.should_receive(:render).with(:error)
          controller.send(:load_rule_class_from_model)  
        end          
      end      
    end
  end
end