require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReJob do
  def valid_attributes
    {
      :job_status => RulesEngine::Job::JOB_STATUS_RUNNING
    }
  end
  
  should_validate_presence_of :job_status
  
  it "should be valid with valid attributes" do
    ReJob.new(valid_attributes).should be_valid
  end

  should_have_many :re_job_audits
  
  describe "finding jobs" do
    describe "jobs not started" do
      it "should not be included" do
        re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_NONE)
        re_job.save!
                
        ReJob.find_jobs(:page => 1).length.should == 0
      end        
    end
    
    describe "jobs that are running" do
      before(:each) do
        @re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_RUNNING)
        @re_job.save!
      end

      it "should be included in the audit results" do
        result_set = ReJob.find_jobs(:page => 1)
        result_set.length.should == 1
        result_set[0]["job_id"].to_i.should == @re_job.id
      end

      describe "no audit entries" do
        it "should include the start date from the job" do
          result_set = ReJob.find_jobs(:page => 1)
          result_set[0]["start_date"].should_not be_nil
          # result_set[0]["start_date"].should == @re_job.created_at
        end        
      end
      
      describe "has audit entries" do
        before(:each) do          
          @re_audit_date = Time.parse("April 24 2010")        
          @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => @re_audit_date, :re_pipeline_id => 1001)
          @re_job.save!
        end
        
        it "should include the start date from the audit entries" do
          result_set = ReJob.find_jobs(:page => 1)
          result_set[0]["start_date"].should_not be_nil
          result_set[0]["start_date"].should == @re_audit_date.utc
        end        
        
      end
  
      it "should not include the end data when end not set" do
        result_set = ReJob.find_jobs(:page => 1)
        result_set[0]["end_date"].should be_nil
      end
    end

    describe "jobs that are finished" do
      before(:each) do
        @re_audit_date_start = Time.parse("April 24 2010")
        @re_audit_date_end = Time.parse("April 25 2010")
        
        @re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_SUCCESS)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => @re_audit_date_start, :re_pipeline_id => 1001)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => @re_audit_date_end, :re_pipeline_id => 2001)      
        @re_job.save!
      end

      it "should be included in the results" do
        result_set = ReJob.find_jobs(:page => 1)
        result_set.length.should == 1
        result_set[0]["job_id"].to_i.should == @re_job.id
      end

      it "should include the start data" do
        result_set = ReJob.find_jobs(:page => 1)
        result_set[0]["start_date"].should_not be_nil        
        result_set[0]["start_date"].should == @re_audit_date_start.utc
      end
  
      it "should include the end date" do
        result_set = ReJob.find_jobs(:page => 1)
        result_set[0]["end_date"].should_not be_nil
        result_set[0]["end_date"].should == @re_audit_date_end.utc
      end        
    end
  end
  
  describe "finding jobs by the pipeline" do

    describe "jobs not started" do
      it "should not be included" do
        re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_NONE)
        re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 1001)
        re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 2001)      
        re_job.save!
                
        ReJob.find_jobs_by_pipeline(1001, :page => 1).length.should == 0
      end        
    end
    
    describe "jobs that are running" do
      before(:each) do
        @re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_RUNNING)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 1001)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 2001)      
        @re_job.save!
      end

      it "should be included in the results" do
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
    end

    describe "jobs that are finished" do
      before(:each) do
        @re_job = ReJob.new(:job_status => RulesEngine::Job::JOB_STATUS_SUCCESS)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 1001)
        @re_job.re_job_audits << ReJobAudit.new(:audit_code => RulesEngine::Audit::AUDIT_SUCCESS, :audit_date => Time.now, :re_pipeline_id => 2001)      
        @re_job.save!
      end

      it "should be included in the results" do
        result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
        result_set.length.should == 1
        result_set[0]["job_id"].to_i.should == @re_job.id
      end

      it "should include the start data" do
        result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
        result_set[0]["start_date"].should_not be_nil
      end
  
      it "should include the end date" do
        result_set = ReJob.find_jobs_by_pipeline(1001, :page => 1)
        result_set[0]["end_date"].should_not be_nil
      end        
    end
  end
end
