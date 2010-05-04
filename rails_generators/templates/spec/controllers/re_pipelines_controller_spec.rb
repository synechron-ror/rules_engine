require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

%w(lookup index show new create change edit update activate deactivate revert destroy).each do |action|
  %w(editor reader).each do |type|
    shared_examples_for "re_#{type}_access_required_for_#{action}" do
      before do
        controller.stub!(:"re_#{type}_access_required").and_return(false)
      end

      it "should confirm #{type} when calling #{action}" do
        get action
      end
    end
  end  
end

describe RePipelinesController do
  it_should_behave_like "rules_engine_reader_access_required_for_lookup"
  it_should_behave_like "rules_engine_reader_access_required_for_index"
  it_should_behave_like "rules_engine_reader_access_required_for_show"
  
  it_should_behave_like "rules_engine_editor_access_required_for_new"
  it_should_behave_like "rules_engine_editor_access_required_for_create"
  it_should_behave_like "rules_engine_editor_access_required_for_change"
  it_should_behave_like "rules_engine_editor_access_required_for_edit"
  it_should_behave_like "rules_engine_editor_access_required_for_update"
  it_should_behave_like "rules_engine_editor_access_required_for_activate"
  it_should_behave_like "rules_engine_editor_access_required_for_deactivate"
  it_should_behave_like "rules_engine_editor_access_required_for_revert"
  it_should_behave_like "rules_engine_editor_access_required_for_destroy"
  
  before do
    controller.stub!(:rules_engine_editor_access_required).and_return(true)
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
  end
  
  describe "index" do
    it "should get the list of pipelines" do
      re_pipelines = [1, 2]
      RePipeline.should_receive(:find).with(:all).and_return(re_pipelines)
      get :index
      assigns[:re_pipelines].should == re_pipelines
    end

    describe "sorting the results" do
      # it "should sort by title by default" do
      #   RePipeline.stub!(:by_not_archived).and_return(RePipeline)
      #   RePipeline.should_receive(:order_title).and_return(RePipeline)
      #   get :index
      # end
    end
    
    describe "filtering the results" do
      # it "should include not archived pipelines by default" do
      #   RePipeline.should_receive(:by_not_archived).and_return(RePipeline)
      #   get :index
      # end
    end
  end
  
  describe "GET show" do
    it "should get the pipeline record with the ID" do
      RePipeline.should_receive(:find).with("123")
      get :show, :id => 123
    end
  end
    
  # describe "GET new" do
  #   it "should provide a fresh pipeline object" do
  #     RePipeline.should_receive :new
  #     get :new
  #   end
  # end
  #   
  # describe "POST create" do
  #   before do
  #     @re_pipeline = mock_model(RePipeline, :save => false)
  #     RePipeline.stub!(:new).and_return(@re_pipeline) 
  #   end
  #   
  #   describe "creation failed" do
  #     it "should render the 'new' template" do
  #       post :create, :re_pipeline => { :key => "value" }
  #       response.should render_template(:new)
  #     end
  #   end
  #   
  #   describe "pipeline created" do
  #     before do
  #       @re_pipeline.stub!(:save).and_return(true)
  #     end
  #     
  #     it "should save the re_pipeline" do
  #       @re_pipeline.should_receive :save
  #       post :create, :re_pipeline => { :key => "value" }
  #     end
  #     
  #     it "should display a flash success message" do
  #       post :create, :re_pipeline => { :key => "value" }
  #       flash[:success].should_not be_blank
  #     end
  #     
  #     it "should redirect to the show re_pipeline page" do
  #       post :create, :re_pipeline => { :key => "value" }
  #       response.should redirect_to(re_pipeline_path(@re_pipeline))
  #     end
  #   end
  # end
  
  
end