require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReJob do
  def valid_attributes
    {
      :job_status => ReJob::JOB_STATUS_NONE
    }
  end
  
  should_validate_presence_of :job_status
  
  it "should be valid with valid attributes" do
    ReJob.new(valid_attributes).should be_valid
  end

  should_have_many :re_job_audits

  describe "finding jobs" do
    before(:each) do
      @re_job = ReJob.new(valid_attributes)
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_START, :audit_date => Time.now, :re_pipeline_id => 1001)
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_START, :audit_date => Time.now, :re_pipeline_id => 2001)      
      @re_job.save!
    end
    
    it "should include jobs that have started" do
      result_set = ReJob.find_jobs(:page => 1)
      result_set.length.should == 1
      result_set[0]["job_id"].to_i.should == @re_job.id
    end
    
    it "should include the start data" do
      result_set = ReJob.find_jobs(:page => 1)
      result_set[0]["start_date"].should_not be_nil
    end

    it "should not include the end data when end not set" do
      result_set = ReJob.find_jobs(:page => 1)
      result_set[0]["end_date"].should be_nil
    end

    it "should include the end data" do
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_END, :audit_date => Time.now, :re_pipeline_id => 1001)

      result_set = ReJob.find_jobs(:page => 1)
      result_set[0]["end_date"].should_not be_nil
    end        
    
  end

  describe "finding jobs by the pipeline" do
    before(:each) do
      @re_job = ReJob.new(valid_attributes)
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_START, :audit_date => Time.now, :re_pipeline_id => 1001)
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_START, :audit_date => Time.now, :re_pipeline_id => 2001)      
      @re_job.save!
    end
    
    it "should include jobs where the job audit has started in the pipeline" do
      result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
      result_set.length.should == 1
      result_set[0]["job_id"].to_i.should == @re_job.id
    end

    it "should include the start data" do
      result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
      result_set[0]["start_date"].should_not be_nil
    end

    it "should not include the end data when end not set" do
      result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
      result_set[0]["end_date"].should be_nil
    end

    it "should include the end data" do
      @re_job.re_job_audits << ReJobAudit.new(:audit_code => ReJobAudit::AUDIT_PIPELINE_END, :audit_date => Time.now, :re_pipeline_id => 1001)

      result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
      result_set[0]["end_date"].should_not be_nil
    end        
  end
  
end
