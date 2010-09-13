require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePublicationsController do
  extend RulesEngineMacros
  
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
  end  

  describe "show" do
    it_should_require_rules_engine_reader_access(:show, :id => 123)
    
    it "should get the audit history record with the process ID" do
      re_plan = RePlan.make(:code => "mock_code")
      
      publisher = mock('publisher')
      RulesEngine::Publish.stub!(:publisher).and_return(publisher)
      
      re_publications = {:history => "none"}
      publisher.should_receive(:history).with("mock_code", anything).and_return(re_publications)
      
      get :show, :id => re_plan.id
      assigns[:re_publications].should == re_publications
    end
  end
end
