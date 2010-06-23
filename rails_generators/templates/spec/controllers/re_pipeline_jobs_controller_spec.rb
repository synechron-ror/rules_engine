require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePipelineJobsController do
  extend RulesEngineMacros
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    
    @re_pipeline = mock_model(RePipeline)
    RePipeline.stub!(:find).and_return(@re_pipeline)
  end  

  describe "index" do    
    it_should_require_rules_engine_reader_access(:index, :re_pipeline_id => "1001")

    it "should load the pipeline" do
      RePipeline.should_receive(:find).with("1001").and_return(@re_pipeline)
      get :index, :re_pipeline_id => "1001"
      assigns[:re_pipeline].should == @re_pipeline
    end

    it "should find_jobs for this pipeline" do
      re_jobs = [1, 2]
      ReJob.should_receive(:find_jobs_by_pipeline).with(@re_pipeline.id, anything).and_return(re_jobs)
      
      get :index, :re_pipeline_id => "1001"      
      assigns[:re_jobs].should == re_jobs
    end
    
    it "should use pagination" do
      ReJob.should_receive(:find_jobs_by_pipeline).with(anything, :page => "101", :per_page => 20)
      get :index, :re_pipeline_id => "1001", :page => 101
    end
  end

end