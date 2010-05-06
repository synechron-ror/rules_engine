require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReJobsController do
  extend RulesEngineMacros
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
  end  

  describe "index" do    
    it_should_require_rules_engine_reader_access(:index)
    
    it "should get the list of jobs" do
      re_jobs = [1, 2]
      ReJob.should_receive(:find_jobs).and_return(re_jobs)
      get :index
      assigns[:re_jobs].should == re_jobs
    end
    
    it "should use pagination" do
      ReJob.should_receive(:find_jobs).with(:page => "101", :per_page => 20)
      get :index, :page => 101
    end
  end

  describe "show" do    
    it_should_require_rules_engine_reader_access(:show)
    
    it "should get the job" do
      re_job = mock_model(ReJob)
      ReJob.should_receive(:find).with("101").and_return(re_job)
      get :show, :id => 101
      assigns[:re_job].should == re_job
    end
    
    it "should set the job audits" do
      re_job = mock_model(ReJob)
      ReJob.stub!(:find).with("101").and_return(re_job)
      
      re_job_audits = [1, 2]
      ReJobAudit.should_receive(:by_re_job_id).with(re_job.id).and_return(ReJobAudit)
      ReJobAudit.stub!(:find).and_return(re_job_audits)
      
      get :show, :id => 101
      assigns[:re_job_audits].should == re_job_audits
    end
        
  end
end