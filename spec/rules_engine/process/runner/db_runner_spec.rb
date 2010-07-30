require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "RulesEngine::Process::ReProcessRun" do
  before(:each) do
    RulesEngine::Process.runner = :db_runner
    RulesEngine::Process.auditor = nil
    
    @now = Time.now
    @re_process_run_1 = RulesEngine::Process::ReProcessRun.create(:plan_code => 'mock_code', 
                                                                         :process_status => RulesEngine::Process::PROCESS_STATUS_NONE,
                                                                         :started_at => nil,
                                                                         :finished_at => nil)
    
    @re_process_run_2 = RulesEngine::Process::ReProcessRun.create(:plan_code => 'mock_code', 
                                                                         :process_status => RulesEngine::Process::PROCESS_STATUS_RUNNING,
                                                                         :started_at => @now, 
                                                                         :finished_at => nil)
    
    @re_process_run_3 = RulesEngine::Process::ReProcessRun.create(:plan_code => 'mock_code', 
                                                                         :process_status => RulesEngine::Process::PROCESS_STATUS_SUCCESS,
                                                                         :started_at => @now - 1.minute, 
                                                                         :finished_at => @now + 1.minute)
                                                                         
    @re_process_run_4 = RulesEngine::Process::ReProcessRun.create(:plan_code => 'mock_code', 
                                                                         :process_status => RulesEngine::Process::PROCESS_STATUS_FAILURE,
                                                                         :started_at => @now - 2.minute, 
                                                                         :finished_at => @now + 2.minute)

    @re_process_run_5 = RulesEngine::Process::ReProcessRun.create(:plan_code => 'invalid_dates', 
                                                                         :process_status => RulesEngine::Process::PROCESS_STATUS_RUNNING,
                                                                         :started_at => @now - 3.minute, 
                                                                         :finished_at => nil)
                                                 
  end
  
  describe "history" do
    describe "no plan code set" do
      it "should get all the active proceses in start date order" do
        RulesEngine::Process::ReProcessRun.history(nil).should == [@re_process_run_2, @re_process_run_3, @re_process_run_4, @re_process_run_5]
      end

      it "should use pagination" do
        RulesEngine::Process::ReProcessRun.should_receive(:paginate).with(hash_including(:page => 1, :per_page => 10))
        RulesEngine::Process::ReProcessRun.history(nil)
      end

      it "should use set pagination" do
        RulesEngine::Process::ReProcessRun.should_receive(:paginate).with(hash_including(:page => 2, :per_page => 999))
        RulesEngine::Process::ReProcessRun.history(nil, {:page => 2, :per_page => 999})
      end
    end
  end
end

describe "RulesEngine::Process::DbRunner" do
  before(:each) do
    RulesEngine::Process.runner = :db_runner
    RulesEngine::Process.auditor = nil
    
    @now = Time.now
    @re_process_run = mock_model(RulesEngine::Process::ReProcessRun)
    @re_process_run.stub!(:plan_code).and_return('mock code')
    @re_process_run.stub!(:plan_version).and_return(1002)
    @re_process_run.stub!(:process_status).and_return(RulesEngine::Process::PROCESS_STATUS_FAILURE)
    @re_process_run.stub!(:started_at).and_return(@now)
    @re_process_run.stub!(:finished_at).and_return(@now + 1.minute)
    @re_process_run.stub!(:update_attributes)
    
    page_data = [@re_process_run, @re_process_run]
    page_data.stub!(:next_page => "103")
    page_data.stub!(:previous_page => "101")
    
    RulesEngine::Process::ReProcessRun.stub!(:create).and_return(@re_process_run)
    RulesEngine::Process::ReProcessRun.stub!(:history).and_return(page_data)    
    RulesEngine::Process::ReProcessRun.stub!(:find_by_id).and_return(@re_process_run)
    
  end
  
  describe "setting the runner" do
    it "should set the runner to the database process runner" do
      RulesEngine::Process.runner.should be_instance_of(RulesEngine::Process::DbRunner)
    end
  end
  
  describe "creating a new process" do
    it "should create a new process with status NONE" do
      RulesEngine::Process::ReProcessRun.should_receive(:create).with(hash_including(:process_status => RulesEngine::Process::PROCESS_STATUS_NONE))
      RulesEngine::Process.runner.create
    end
    
    it "should return the new id of the created run" do
      @re_process_run.stub!(:id).and_return(101999)
      RulesEngine::Process.runner.create.should == 101999
    end
  end      
  
  describe "running a plan" do
    before(:each) do
      @plan = {"code" => 'mock_plan', "version" => 1009, "workflow" => "db_runner_workflow"}
    end
    
    it "should get the created process" do      
      RulesEngine::Process::ReProcessRun.should_receive(:find_by_id).with(1009)
      RulesEngine::Process.runner.run_plan(1009, @plan, {})
    end
    
    describe "process not found" do
      before(:each) do
        RulesEngine::Process::ReProcessRun.stub!(:find_by_id).with(1009).and_return(nil)
      end
      
      it "should return false" do
        RulesEngine::Process.runner.run_plan(1009, @plan, {}).should == false
      end
      
      it "should audit the error" do
        RulesEngine::Process.auditor.should_receive(:audit).with(1009, "Process missing", RulesEngine::Process::AUDIT_FAILURE)
        RulesEngine::Process.runner.run_plan(1009, @plan, {})
      end              
    end
    
    describe "updateing the plan" do
      it "should update the plan code" do
        @re_process_run.should_receive(:update_attributes).once.with(hash_including(:plan_code => 'mock_plan'))
        RulesEngine::Process.runner.run_plan(1009, @plan, {})                                                        
      end
    
      it "should update the plan version" do
        @re_process_run.should_receive(:update_attributes).once.with(hash_including(:plan_version => 1009))
        RulesEngine::Process.runner.run_plan(1009, @plan, {})                                                        
      end
    
      it "should update the plan as running" do
        @re_process_run.should_receive(:update_attributes).once.with(hash_including(:process_status => RulesEngine::Process::PROCESS_STATUS_RUNNING))
        RulesEngine::Process.runner.run_plan(1009, @plan, {})                                                        
      end
    end
    
    it "should run the plan" do
      RulesEngine::Process.runner.should_receive(:_run_plan_workflow).with(1009, @plan, "db_runner_workflow", {:test => "data"})
      RulesEngine::Process.runner.run_plan(1009, @plan, {:test => "data"})                                                        
    end                  
  
    describe "running the plan was successfull" do
      before(:each) do
        RulesEngine::Process.runner.should_receive(:_run_plan_workflow).and_return(true)
      end
      
      it "should update the status as finished success" do
        @re_process_run.should_receive(:update_attributes).once.with(hash_including(:process_status => RulesEngine::Process::PROCESS_STATUS_SUCCESS))
        RulesEngine::Process.runner.run_plan(1009, @plan, {})                                                        
      end
      
      it "should return success" do
        RulesEngine::Process.runner.run_plan(1009, @plan, {}).should == true
      end
    end  
    
    describe "running the plan failed" do
      before(:each) do
        RulesEngine::Process.runner.should_receive(:_run_plan_workflow).and_return(false)
      end
      
      it "should update the status as failed" do
        @re_process_run.should_receive(:update_attributes).once.with(hash_including(:process_status => RulesEngine::Process::PROCESS_STATUS_FAILURE))
        RulesEngine::Process.runner.run_plan(1009, @plan, {})                                                        
      end

      it "should return failure" do
        RulesEngine::Process.runner.run_plan(1009, @plan, {}).should == false
      end
    end      
  end
  
  describe "getting the process status" do
    it "should get the process" do
      RulesEngine::Process::ReProcessRun.should_receive(:find_by_id).with(1009)
      RulesEngine::Process.runner.status(1009)
    end
    
    describe "process not found" do
      it "should return status NONE" do
        RulesEngine::Process::ReProcessRun.stub!(:find_by_id).and_return(nil)
        RulesEngine::Process.runner.status(1009).should == RulesEngine::Process::PROCESS_STATUS_NONE
      end
    end    

    describe "process found" do
      it "should return process status" do
        RulesEngine::Process::ReProcessRun.stub!(:find_by_id).and_return(@re_process_run)
        @re_process_run.should_receive(:process_status).and_return(1002)
        RulesEngine::Process.runner.status(1009).should == 1002
      end
    end    
  end
  
  describe "getting the process run history" do
    it "should returns a hash of the process data " do
      data = RulesEngine::Process.runner.history('mock_code')
      data.should be_instance_of(Hash)
    end
    
    it "should include an array of publications" do
      data = RulesEngine::Process.runner.history('mock_code')
      versions = data["processes"]
      versions.should be_instance_of(Array)
    end  
    
    it "should include the publication information" do
      data = RulesEngine::Process.runner.history('mock_code')
      processes = data["processes"]
      
      processes.length.should == 2
      processes[0]["plan_code"].should == 'mock code'
      processes[0]["plan_version"].should == 1002
      processes[0]["process_status"].should == RulesEngine::Process::PROCESS_STATUS_FAILURE
      processes[0]["started_at"].should == @now.utc.to_s
      processes[0]["finished_at"].should == (@now + 1.minute).utc.to_s
  
      processes[1]["plan_code"].should == 'mock code'
      processes[0]["plan_version"].should == 1002
      processes[1]["process_status"].should == RulesEngine::Process::PROCESS_STATUS_FAILURE
      processes[1]["started_at"].should == @now.utc.to_s
      processes[1]["finished_at"].should == (@now + 1.minute).utc.to_s
    end
  end
    
end
