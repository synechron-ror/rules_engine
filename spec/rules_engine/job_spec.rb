require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ReJob
  JOB_STATUS_NONE =     1234
  JOB_STATUS_RUNNING =  2345
  JOB_STATUS_SUCCESS =  3456
  JOB_STATUS_FAILURE =  4567
end

class RePipelineActivated
end

class ReJobAudit
  AUDIT_INFO =      1234
  AUDIT_SUCCESS =   2345
  AUDIT_FAILURE =   3456
end

describe "RulesEngine::Job" do
  describe "create" do
    before(:each) do
      @re_job = ReJob.new
      ReJob.stub!(:create).and_return(@re_job)
    end
    
    it "should create a new job" do
      ReJob.should_receive(:create)
      RulesEngine::Job.create
    end
    
    it "should set the job status as none" do
      ReJob.should_receive(:create).with(:job_status => ReJob::JOB_STATUS_NONE)
      RulesEngine::Job.create
    end
        
    it "should return the created job" do
      RulesEngine::Job.should_receive(:new).with(@re_job).and_return(job = mock('job'))
      RulesEngine::Job.create.should == job
    end
  end

  describe "open" do
    before(:each) do
      @re_job = ReJob.new
      @re_job.stub!(:update_attributes)
      ReJob.stub!(:find_by_id).with(1001).and_return(@re_job)
      ReJob.stub!(:create).and_return(@re_job)
    end
    
    it "should load the job" do
      ReJob.should_receive(:find_by_id).with(1001).and_return(@re_job)
      RulesEngine::Job.open(1001)
    end

    it "should create the if not loaded" do
      ReJob.should_receive(:find_by_id).with(1001).and_return(nil)
      ReJob.should_receive(:create).and_return(@re_job)
      RulesEngine::Job.open(1001)
    end
        
    it "should set the job status as none" do
      @re_job.should_receive(:update_attributes).with(:job_status => ReJob::JOB_STATUS_NONE)
      RulesEngine::Job.open(1001)
    end
        
    it "should return the created job" do
      RulesEngine::Job.should_receive(:new).with(@re_job).and_return(job = mock('job'))
      RulesEngine::Job.open(1001).should == job
    end
  end
  
  describe "run" do
#     def run_pipeline
#       RulesEngine::JobRunner.run_pipleine(1001, 'mock pipeline code',{:data_key => "data value"})
#     end
#     
    before(:each) do
      @re_job = ReJob.new
      @re_job.stub!(:id).and_return(1001)
      @re_job.stub!(:update_attributes)
      ReJob.stub!(:create).and_return(@re_job)
            
      @re_pipeline_activated = RePipelineActivated.new
      @re_pipeline_activated.stub!(:id)
      RePipelineActivated.stub!(:find_by_code).and_return(@re_pipeline_activated)
      
      @re_pipeline = mock("RePipeline")
      @re_pipeline.stub!(:id).and_return(2001)
      @re_pipeline_activated.stub!(:re_pipeline).and_return(@re_pipeline)
            
      @rule_1 = mock("Rule")
      @rule_1.stub!(:process).and_return(nil)      
      
      @re_rule_1 = mock("ReRule")
      @re_rule_1.stub!(:id).and_return(3001)
      @re_rule_1.stub!(:title).and_return('rule 1')
      @re_rule_1.stub!(:rule_class_name).and_return('rule_1')
      @re_rule_1.stub!(:rule).and_return(@rule_1)
      
      @rule_2 = mock("Rule")
      @rule_2.stub!(:process).and_return(nil)

      @re_rule_2 = mock("ReRule")
      @re_rule_2.stub!(:id).and_return(3002)
      @re_rule_2.stub!(:title).and_return('rule 2')
      @re_rule_2.stub!(:rule_class_name).and_return('rule_2')
      @re_rule_2.stub!(:rule).and_return(@rule_2)
      
      @re_pipeline_activated.stub!(:re_rules).and_return([@re_rule_1, @re_rule_2])
      
      ReJobAudit.stub!(:create)
    end
    
    it "should fail if the job if it is not found" do
      ReJob.should_receive(:create).and_return(nil)
      job = RulesEngine::Job.create
      job.run("test").should == false
    end

    it "should set the job as running" do
      @re_job.should_receive(:update_attributes).at_least(:once).with(:job_status => ReJob::JOB_STATUS_RUNNING)
      RulesEngine::Job.create.run("test")
    end

    it "should fail if the activated pipeline is not found" do
      RePipelineActivated.should_receive(:find_by_code).and_return(nil)
      RulesEngine::Job.create.run("test").should == false
    end

    it "should fail if the activated pipeline has no rules" do
      @re_pipeline_activated.should_receive(:re_rules).and_return([])
      RulesEngine::Job.create.run("test").should == false
    end

    it "should fail if the Rules Engine does not know about the rule" do
      @re_rule_1.should_receive(:rule).and_return(nil)
      RulesEngine::Job.create.run("test").should == false
    end

    it "should process all of the rules if the outcome is nil" do
      @rule_1.should_receive(:process).and_return(nil)
      @rule_2.should_receive(:process).and_return(nil)
      
      RulesEngine::Job.create.run("test").should == true
    end

    it "should process all of the rules if the outcome is OUTCOME_NEXT" do
      rule_outcome = RulesEngine::RuleOutcome.new
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_NEXT
      
      @rule_1.should_receive(:process).and_return(rule_outcome)
      @rule_2.should_receive(:process).and_return(rule_outcome)
      
      RulesEngine::Job.create.run("test").should == true
    end

    it "should not process rule 2 if rule 1 is OUTCOME_STOP_FAILURE" do
      rule_outcome = RulesEngine::RuleOutcome.new
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
      
      @rule_1.should_receive(:process).and_return(rule_outcome)
      @rule_2.should_not_receive(:process)
      
      RulesEngine::Job.create.run("test").should == false
    end

    it "should not process rule 2 if rule 1 is OUTCOME_STOP_SUCCESS" do
      rule_outcome = RulesEngine::RuleOutcome.new
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
      
      @rule_1.should_receive(:process).and_return(rule_outcome)
      @rule_2.should_not_receive(:process)
      
      RulesEngine::Job.create.run("test").should == true
    end

    it "should start a new pipeline if rule 1 is OUTCOME_START_PIPELINE" do
      rule_outcome_pipeline = RulesEngine::RuleOutcome.new
      rule_outcome_pipeline.outcome = RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
      rule_outcome_pipeline.pipeline_code = "next pipeline"
      
      rule_outcome_stop = RulesEngine::RuleOutcome.new
      rule_outcome_stop.outcome = RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
      
      RePipelineActivated.should_receive(:find_by_code).with("next pipeline").and_return(@re_pipeline_activated)
      
      @rule_1.should_receive(:process).and_return(rule_outcome_pipeline, rule_outcome_stop)
      @rule_2.should_not_receive(:process)
      
      RulesEngine::Job.create.run("test").should == true
    end

    it "should stop if we are starting too many pipelines" do
      rule_outcome = RulesEngine::RuleOutcome.new
      rule_outcome.outcome = RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
      rule_outcome.pipeline_code = "next pipeline"
      
      @rule_1.stub!(:process).and_return(rule_outcome)
      @rule_2.should_not_receive(:process)
      
      RulesEngine::Job.create.run("test").should == false
    end
  end
  
  describe "audit_rule" do
    before(:each) do
      @re_job = ReJob.new
      @re_job.stub!(:id).and_return(1001)
      # @re_job.stub(:update_attributes)
      ReJob.stub!(:create).and_return(@re_job)
    end
    
    it "should set the job_id" do
      now = Time.now
      Time.stub!(:now).and_return(now)
    
      ReJobAudit.should_receive(:create).with(hash_including(
        :re_job_id => 1001,
        :re_pipeline_id => nil, 
        :re_rule_id => nil,
        :audit_date => now,  
        :audit_code => "mock_code",
        :audit_message => "mock_message"
      ))
      
      job = RulesEngine::Job.create
      job.audit("mock_message", "mock_code")
    end

    it "should set the re_pipeline_id" do
      now = Time.now
      Time.stub!(:now).and_return(now)
    
      ReJobAudit.should_receive(:create).with(hash_including(
        :re_job_id => 1001,
        :re_pipeline_id => 2001, 
        :re_rule_id => nil,
        :audit_date => now,  
        :audit_code => "mock_code",
        :audit_message => "mock_message"
      ))
      
      job = RulesEngine::Job.create
      job.stub!(:re_pipeline).and_return(mock("RePipeline", :id => 2001))
      job.audit("mock_message", "mock_code")
    end
    
    it "should set the re_rule_id" do
      now = Time.now
      Time.stub!(:now).and_return(now)
    
      ReJobAudit.should_receive(:create).with(hash_including(
        :re_job_id => 1001,
        :re_pipeline_id => nil, 
        :re_rule_id => 3001,
        :audit_date => now,  
        :audit_code => "mock_code",
        :audit_message => "mock_message"
      ))
      
      job = RulesEngine::Job.create
      job.stub!(:re_rule).and_return(mock("ReRule", :id => 3001))
      job.audit("mock_message", "mock_code")
    end
  end
end
