require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Process::Runner" do

  describe "setting the auditor" do
    it "should set the auditor as a instance of a class" do
      mock_auditor = mock('mock_auditor')
      RulesEngine::Process.auditor = mock_auditor
      RulesEngine::Process.auditor.should == mock_auditor
    end

    it "should set the auditor to the database plan auditor" do
      RulesEngine::Process.auditor = :db_auditor
      RulesEngine::Process.auditor.should be_instance_of(RulesEngine::Process::DbAuditor)
    end
  end
  
  describe "getting the auditor" do
    it "should get the default auditor when not set" do
      RulesEngine::Process.auditor = nil
      RulesEngine::Process.auditor.should be_instance_of(RulesEngine::Process::Auditor)
    end        
  end
  
  describe "auditing a message" do
    before(:each) do
      @auditor = RulesEngine::Process::Auditor.new
    end
    
    describe "rails logger defined" do
      before(:each) do
        # Rails = mock("Rails")
        @mock_logger = mock('Logger')
        @mock_logger.stub!(:error)
        @mock_logger.stub!(:info)
        Rails.stub(:logger).and_return(@mock_logger)
      end
      
      it "should not audit if perform_audit? false" do
        @mock_logger.should_not_receive(:error)
        @auditor.stub!(:perform_audit?).and_return(false)
        @auditor.audit(1001, "failure", RulesEngine::Process::AUDIT_FAILURE)
      end
      
      it "should wite to the error log for error audit messaged" do
        @mock_logger.should_receive(:error)
        @auditor.audit(1001, "failure", RulesEngine::Process::AUDIT_FAILURE)
      end

      it "should wite to the info log for success audit messaged" do
        @mock_logger.should_receive(:info)
        @auditor.audit(1001, "failure", RulesEngine::Process::AUDIT_SUCCESS)
      end

      it "should wite to the info log for info audit messaged" do
        @mock_logger.should_receive(:info)
        @auditor.audit(1001, "failure", RulesEngine::Process::AUDIT_INFO)
      end
    end
    
    describe "rails logger not defined" do
      before(:each) do
        Rails.stub(:logger).and_return(nil)
      end
      
      it "should wite to the $stderr" do
        $stderr.should_receive(:puts)
        @auditor.audit(1001, "failure")
      end
    end
    
  end
  
  describe "getting the audit history" do
    it "should return a hash " do
      auditor = RulesEngine::Process::Auditor.new
      auditor.history(1001, {}).should be_instance_of(Hash)
    end

    it "should return an array of audits" do
      auditor = RulesEngine::Process::Auditor.new
      auditor.history(1001, {})["audits"].should be_instance_of(Array)
    end
  end

  describe "perform_audit" do
    before(:each) do
      @auditor = RulesEngine::Process::Auditor.new
    end

    it "should be true if audit_level is not set " do
      @auditor.audit_level = nil
      @auditor.perform_audit?(RulesEngine::Process::AUDIT_INFO).should == true
    end

    it "should be false if audit_level is AUDIT_NONE " do
      @auditor.audit_level = RulesEngine::Process::AUDIT_NONE
      @auditor.perform_audit?(RulesEngine::Process::AUDIT_INFO).should == false
    end

    it "should be true if audit_level is AUDIT_INFO " do
      @auditor.audit_level = RulesEngine::Process::AUDIT_INFO
      @auditor.perform_audit?(RulesEngine::Process::AUDIT_INFO).should == true
    end

    it "should be false if audit_level is AUDIT_SUCCESS " do
      @auditor.audit_level = RulesEngine::Process::AUDIT_SUCCESS
      @auditor.perform_audit?(RulesEngine::Process::AUDIT_INFO).should == false
    end
  end
end
