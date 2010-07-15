require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Process::Runner" do

  describe "setting the runner" do
    it "should set the runner as a instance of a class" do
      mock_runner = mock('mock_runner')
      RulesEngine::Process.runner = mock_runner
      RulesEngine::Process.runner.should == mock_runner
    end

    it "should set the runner to the database plan runner" do
      RulesEngine::Process.runner = :db_runner
      RulesEngine::Process.runner.should be_instance_of(RulesEngine::Process::DbRunner)
    end
  end
  
  describe "getting the runner" do
    it "should throw an exception if the runner is not set" do
      RulesEngine::Process.runner = nil
      
      lambda {
        RulesEngine::Process.runner
      }.should raise_error
    end        
  end
  
  describe "creating a process" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Process::Runner.new.create()
      }.should raise_error
    end
  end
  # 
  # describe "getting a plan" do
  #   it "should throw an error if not overwritten" do
  #     lambda {
  #       RulesEngine::Process::Runner.new.get('code', '1.0.0.1')
  #     }.should raise_error
  #   end
  # end
  # 
  # describe "getting the history" do
  #   it "should throw an error if not overwritten" do
  #     lambda {
  #       RulesEngine::Process::Runner.new.history('code', {:dummy => "option"})
  #     }.should raise_error
  #   end
  # end
  # 
  # describe "removing a plan" do
  #   it "should throw an error if not overwritten" do
  #     lambda {
  #       RulesEngine::Process::Runner.new.remove('code')
  #     }.should raise_error
  #     
  #     lambda {
  #       RulesEngine::Process::Runner.new.remove('code', 1)
  #     }.should raise_error
  #     
  #   end
  # end
end
