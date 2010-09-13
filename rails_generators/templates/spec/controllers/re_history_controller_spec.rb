require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReHistoryController do
  extend RulesEngineMacros
  
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
  end  

  describe "index" do
    it_should_require_rules_engine_reader_access(:index)
    
    it "should get the process runner history from the rules engine process runner" do
      runner = mock('runner')
      RulesEngine::Process.stub!(:runner).and_return(runner)
      
      re_history = {:history => "none"}
      runner.should_receive(:history).with(nil, anything()).and_return(re_history)
      get :index
      assigns[:re_history].should == re_history
    end
  end

  describe "show" do
    it_should_require_rules_engine_reader_access(:show, :id => 123)
    
    it "should get the audit history record with the process ID" do
      auditor = mock('auditor')
      RulesEngine::Process.stub!(:auditor).and_return(auditor)
      
      re_audit_history = {:history => "none"}
      auditor.should_receive(:history).with("123").and_return(re_audit_history)
      
      get :show, :id => 123
      assigns[:re_audit_history].should == re_audit_history
    end
  end
end
