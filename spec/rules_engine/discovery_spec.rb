require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "RulesEngine::Discovery" do
  before(:each) do
    Dir.stub!(:glob).and_return(["#{RAILS_ROOT}/app/rules/mock_rule"])
  end
  
  it "should does find all of the rules ruby files in the /app/rules directory " do
    Dir.should_receive(:glob).with(/app\/rules\/\*\*\/\*.rb/).and_return([])
    RulesEngine::Discovery.discover!
  end

  it "should use the rules filename to define the rule class name" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_classes.should include(MockRule)
  end

  it "should add the rule to the rule group" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_groups['mock group'].should include(MockRule)
  end
  
  it "should return the class that matches the name" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_class('mock_rule').should == MockRule
  end

  it "should return nil if the class is unknown" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_class('unknown').should be_nil
  end
end
