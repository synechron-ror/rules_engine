require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePipelinesController do
  extend RulesEngineMacros
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
  end  

  describe "lookup" do
    before(:each) do      
      re_pipeline_1 = mock_model(RePipeline, :title => "title one", :code => "code one")
      re_pipeline_2 = mock_model(RePipeline, :title => "title two", :code => "code two")      
      RePipeline.stub!(:find).and_return([re_pipeline_1, re_pipeline_2])
    end

    it_should_require_rules_engine_reader_access(:lookup)
    
    describe "no query type(t) parameter" do
      it "should return a list of titles by default" do
        get :lookup
        response.body.should == "title one\ntitle two"
      end

      it "should limit the results to 10" do
        RePipeline.should_receive(:find).with(:all, hash_including(:limit => 10))
        get :lookup
      end

      it "should order by title" do
        RePipeline.should_receive(:find).with(:all, hash_including(:order => "title"))
        get :lookup
      end
    end

    describe "query parameter 'q' set" do
      it "should return a list of titles by default" do
        get :lookup, :q => 'mock title'
        response.body.should == "title one\ntitle two"
      end

      it "should limit the results to 10" do
        RePipeline.should_receive(:find).with(:all, hash_including(:limit => 10))
        get :lookup, :q => 'mock title'
      end

      it "should order by title" do
        RePipeline.should_receive(:find).with(:all, hash_including(:order => "title"))
        get :lookup, :q => 'mock title'
      end

      it "should filter by title" do
        RePipeline.should_receive(:find).with(:all, hash_including(:conditions => ["title LIKE ?", "mock title%"]))
        get :lookup, :q => 'mock title'
      end
    end

    describe "query type 't' set to code" do
      it "should return a list of titles by default" do
        get :lookup, :t => "code"
        response.body.should == "code one\ncode two"
      end

      it "should limit the results to 10" do
        RePipeline.should_receive(:find).with(:all, hash_including(:limit => 10))
        get :lookup, :t => "code"
      end

      it "should order by code" do
        RePipeline.should_receive(:find).with(:all, hash_including(:order => "code"))
        get :lookup, :t => "code"
      end
    end

    describe "query type 't' set to code and query parameter 'q' set" do
      it "should return a list of titles by default" do
        get :lookup, :t => "code", :q => 'mock code'
        response.body.should == "code one\ncode two"
      end

      it "should limit the results to 10" do
        RePipeline.should_receive(:find).with(:all, hash_including(:limit => 10))
        get :lookup, :t => "code", :q => 'mock code'
      end

      it "should order by title" do
        RePipeline.should_receive(:find).with(:all, hash_including(:order => "code"))
        get :lookup, :t => "code", :q => 'mock code'
      end

      it "should filter by title" do
        RePipeline.should_receive(:find).with(:all, hash_including(:conditions => ["code LIKE ?", "mock code%"]))
        get :lookup, :t => "code", :q => 'mock code'
      end
    end
  end
  
  describe "index" do
    it_should_require_rules_engine_reader_access(:index)
    
    it "should get the list of pipelines" do
      re_pipelines = [1, 2]
      RePipeline.should_receive(:find).with(:all).and_return(re_pipelines)
      get :index
      assigns[:re_pipelines].should == re_pipelines
    end
  end
  
  describe "show" do
    it_should_require_rules_engine_reader_access(:show)
    
    it "should get the pipeline record with the ID" do
      re_pipeline = mock_model(RePipeline)
      RePipeline.should_receive(:find).with("123").and_return(re_pipeline)
      get :show, :id => 123
      assigns[:re_pipeline].should == re_pipeline
    end
  end

  describe "new" do
    it_should_require_rules_engine_editor_access(:new)
    
    it "should assign a new pipeline record" do
      re_pipeline = mock_model(RePipeline)
      RePipeline.should_receive(:new).and_return(re_pipeline)
      get :new, :id => 123
      assigns[:re_pipeline].should == re_pipeline
    end
    
    it "should render the 'new' template" do
      get :new, :id => 123
      response.should render_template(:new)
    end
  end
    
  describe "create" do
    it_should_require_rules_engine_editor_access(:create)

    before do
      @re_pipeline = mock_model(RePipeline, :save => false)
      RePipeline.stub!(:new).and_return(@re_pipeline) 
    end
    
    it "should assign the re_pipeline parameters" do
      RePipeline.should_receive(:new).with("name" => "name", "value" => "value")
      post :create, :re_pipeline => { :name => "name", :value => "value" }
    end

    it "should save the re_pipeline" do
      @re_pipeline.should_receive(:save)
      post :create, :re_pipeline => { :key => "value" }
    end
        
    describe "save failed" do
      it "should render the 'new' template" do
        post :create, :re_pipeline => { :key => "value" }
        response.should render_template(:new)
      end
    end

    describe "save succeeded" do
      before do
        @re_pipeline.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        post :create, :re_pipeline => { :key => "value" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_pipeline page for HTML" do
        post :create, :re_pipeline => { :key => "value" }
        response.should redirect_to(change_re_pipeline_path(@re_pipeline))
      end

      it "should render 'create' template for JAVASCRIPT" do
        xhr :post, :create, :re_pipeline => { :key => "value" }
        response.should render_template(:create)
      end
    end
  end
    
  describe "change" do
    it_should_require_rules_engine_editor_access(:change)
    
    it "should get the pipeline record with the ID" do
      re_pipeline = mock_model(RePipeline)
      RePipeline.should_receive(:find).with("123").and_return(re_pipeline)
      get :change, :id => 123
      assigns[:re_pipeline].should == re_pipeline
    end
  end

  describe "edit" do
    it_should_require_rules_engine_editor_access(:edit)
    
    it "should get the pipeline record with the ID" do
      re_pipeline = mock_model(RePipeline)
      RePipeline.should_receive(:find).with("123").and_return(re_pipeline)
      get :edit, :id => 123
      assigns[:re_pipeline].should == re_pipeline
    end
  end

  describe "update" do
    it_should_require_rules_engine_editor_access(:update)

    before do
      @re_pipeline = mock_model(RePipeline, :save => false)
      @re_pipeline.stub!(:attributes=)
      RePipeline.stub!(:find).and_return(@re_pipeline) 
    end

    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123").and_return(@re_pipeline)
      put :update, :id => 123, :re_pipeline => { :key => "value" }
      assigns[:re_pipeline].should == @re_pipeline
    end
    
    it "should assign the re_pipeline parameters" do
      @re_pipeline.should_receive(:attributes=).with("name" => "name", "value" => "value")
      put :update, :id => 123, :re_pipeline => { :name => "name", :value => "value" }
    end

    it "should not assign the re_pipeline parameters :code" do
      @re_pipeline.should_receive(:attributes=).with("name" => "name", "value" => "value")
      put :update, :id => 123, :re_pipeline => { :name => "name", :value => "value", :code => "code" }
    end

    it "should save the re_pipeline" do
      @re_pipeline.should_receive(:save)
      put :update, :id => 123, :re_pipeline => { :key => "value" }
    end
        
    describe "save failed" do
      it "should render the 'edit' template" do
        put :update, :id => 123, :re_pipeline => { :key => "value" }
        response.should render_template(:edit)
      end
    end

    describe "save succeeded" do
      before do
        @re_pipeline.stub!(:save).and_return(true)
      end
      
      it "should display a flash success message" do
        put :update, :id => 123, :re_pipeline => { :key => "value" }
        flash[:success].should_not be_blank
      end
      
      it "should redirect to the change re_pipeline page for HTML" do
        put :update, :id => 123, :re_pipeline => { :key => "value" }
        response.should redirect_to(change_re_pipeline_path(@re_pipeline))
      end

      it "should render 'update' template for JAVASCRIPT" do
        xhr :put, :update, :id => 123, :re_pipeline => { :key => "value" }
        response.should render_template(:update)
      end
    end
  end

  
  describe "activate_all" do
    it_should_require_rules_engine_editor_access(:activate_all)

    before do
      @re_pipeline_1 = mock_model(RePipeline)
      @re_pipeline_1.stub!(:activate!)
      @re_pipeline_2 = mock_model(RePipeline)
      @re_pipeline_2.stub!(:activate!)
      RePipeline.stub!(:find).and_return([@re_pipeline_1, @re_pipeline_2])
    end

    it "should get the all of the pipelines" do
      RePipeline.should_receive(:find).with(:all).and_return([@re_pipeline_1, @re_pipeline_2])
      put :activate_all
      assigns[:re_pipelines].should == [@re_pipeline_1, @re_pipeline_2]
    end
    
    it "should activate all of the re_pipeline" do
      @re_pipeline_1.should_receive(:activate!)
      @re_pipeline_2.should_receive(:activate!)
      put :activate_all
    end
       
    it "should display a flash success message" do
      put :activate_all
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the re_pipeline index page for HTML" do
      put :activate_all
      response.should redirect_to(re_pipelines_path)
    end
    
    it "should render 'index' template for JAVASCRIPT" do
      xhr :put, :activate_all
      response.should render_template(:index)
    end    
  end
  
  describe "activate" do
    it_should_require_rules_engine_editor_access(:activate)

    before do
      @re_pipeline = mock_model(RePipeline)
      @re_pipeline.stub!(:activate!)
      RePipeline.stub!(:find).and_return(@re_pipeline) 
    end

    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123").and_return(@re_pipeline)
      put :activate, :id => 123
      assigns[:re_pipeline].should == @re_pipeline
    end
    
    it "should activate the re_pipeline" do
      @re_pipeline.should_receive(:activate!)
      put :activate, :id => 123
    end
   
    it "should display a flash success message" do
      put :activate, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_pipeline page for HTML" do
      put :activate, :id => 123
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :activate, :id => 123
      response.should render_template(:update)
    end    
  end

  describe "deactivate" do
    it_should_require_rules_engine_editor_access(:deactivate)

    before do
      @re_pipeline = mock_model(RePipeline)
      @re_pipeline.stub!(:deactivate!)
      RePipeline.stub!(:find).and_return(@re_pipeline) 
    end

    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123").and_return(@re_pipeline)
      put :deactivate, :id => 123
      assigns[:re_pipeline].should == @re_pipeline
    end
    
    it "should deactivate the re_pipeline" do
      @re_pipeline.should_receive(:deactivate!)
      put :deactivate, :id => 123
    end
   
    it "should display a flash success message" do
      put :deactivate, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_pipeline page for HTML" do
      put :deactivate, :id => 123
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :deactivate, :id => 123
      response.should render_template(:update)
    end    
  end

  describe "revert" do
    it_should_require_rules_engine_editor_access(:revert)

    before do
      @re_pipeline = mock_model(RePipeline)
      @re_pipeline.stub!(:revert!)
      RePipeline.stub!(:find).and_return(@re_pipeline) 
    end

    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123").and_return(@re_pipeline)
      put :revert, :id => 123
      assigns[:re_pipeline].should == @re_pipeline
    end
    
    it "should revert the re_pipeline" do
      @re_pipeline.should_receive(:revert!)
      put :revert, :id => 123
    end
   
    it "should display a flash success message" do
      put :revert, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the change re_pipeline page for HTML" do
      put :revert, :id => 123
      response.should redirect_to(change_re_pipeline_path(@re_pipeline))
    end

    it "should render 'update' template for JAVASCRIPT" do
      xhr :put, :revert, :id => 123
      response.should render_template(:update)
    end    
  end

  describe "destroy" do
    it_should_require_rules_engine_editor_access(:destroy)

    before do
      @re_pipeline = mock_model(RePipeline)
      @re_pipeline.stub!(:destroy)
      RePipeline.stub!(:find).and_return(@re_pipeline) 
    end

    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123").and_return(@re_pipeline)
      delete :destroy, :id => 123
      assigns[:re_pipeline].should == @re_pipeline
    end
    
    it "should destroy the re_pipeline" do
      @re_pipeline.should_receive(:destroy)
      delete :destroy, :id => 123
    end
   
    it "should display a flash success message" do
      delete :destroy, :id => 123
      flash[:success].should_not be_blank
    end
    
    it "should redirect to the re_pipelines page for HTML" do
      delete :destroy, :id => 123
      response.should redirect_to(re_pipelines_path)
    end

    it "should redirect to the re_pipelines page for JAVASCRIPT" do
      xhr :delete, :destroy, :id => 123
      response.body.should == "window.location.href = '#{re_pipelines_path}';"
    end    
  end

  
end