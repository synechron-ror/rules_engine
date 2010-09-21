require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Discovery" do
  before(:each) do
    Dir.stub!(:glob).and_return(["#{Rails.root}/app/rules/mock_rule.rb"])
  end

  describe "setting the rules path" do
    it "use the path to find rules" do
      RulesEngine::Discovery.rules_path = 'dummy'
      Dir.should_receive(:glob).with(/^dummy\/\*\*\/\*.rb$/).and_return([])
      RulesEngine::Discovery.discover!
    end        
    
    it "should return the rules path when set" do
      RulesEngine::Discovery.rules_path = 'dummy'
      RulesEngine::Discovery.rules_path.should =='dummy'
    end
    
    it "should return the \#{Rails.root}/app/rules" do
      RulesEngine::Discovery.rules_path = nil
      RulesEngine::Discovery.rules_path.should == "#{Rails.root}/app/rules"
    end

    it "should throw an exception if not using rails" do
      Rails.stub!(:root).and_return(nil)
      lambda {
        RulesEngine::Discovery.rules_path
      }.should raise_error      
    end
          
  end
  
  describe "rules path not defined" do
    it "should find all of the rules ruby files in the \#{Rails.root}/app/rules directory " do
      Dir.should_receive(:glob).with(/^#{Rails.root}\/app\/rules\/\*\*\/\*.rb$/).and_return([])
      RulesEngine::Discovery.discover!
    end
  end

  it "should use the rules filename to define the rule class name" do
    RulesEngine::Discovery.discover!
    RulesEngine::Discovery.rule_classes.should include(RulesEngine::Rule::MockRule)
  end

  it "should undefine an existing the rule class" do
    RulesEngine::Discovery.discover! 
    RulesEngine::Discovery.rule_class('RulesEngine::Rule::MockRule').options.should == {:group=>"mock group"}
    RulesEngine::Discovery.rule_class('RulesEngine::Rule::MockRule').options[:name] = "test"
    RulesEngine::Discovery.discover! 
    RulesEngine::Discovery.rule_class('RulesEngine::Rule::MockRule').options.should == {:group=>"mock group"}
  end

  it "should add the rule to the rule group" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_groups['mock group'].should include(RulesEngine::Rule::MockRule)
  end
  
  it "should return the class that matches the name" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_class('RulesEngine::Rule::MockRule').should == RulesEngine::Rule::MockRule
  end

  it "should return nil if the class is unknown" do
    RulesEngine::Discovery.discover!      
    RulesEngine::Discovery.rule_class('unknown').should be_nil
  end
  
  describe "the rule class" do
    it "should have a matching rule_class_name" do
      RulesEngine::Discovery.discover!      
      rule = RulesEngine::Discovery.rule_class('RulesEngine::Rule::MockRule')
      rule.rule_class_name.should == 'RulesEngine::Rule::MockRule'
    end        
  end
  
end
