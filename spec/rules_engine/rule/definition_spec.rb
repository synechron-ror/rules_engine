require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class MockRule < RulesEngine::Rule::Definition
end

describe "RulesEngine::Rule::Definition" do
  it "should add a class method rule_class_name" do
    MockRule.methods.should include("rule_class_name")
  end
  
  it "should return the rule_class_name as the rule class" do    
    MockRule.rule_class_name.should == "MockRule"
  end

  it "should be able to set the attribute 'data'" do
    RulesEngine::Rule::Definition.new.methods.should include("data=")
  end

  describe "title" do
    it "should be nil by default" do
      RulesEngine::Rule::Definition.new.title.should be_nil
    end
  end
  
  describe "summary" do
    it "should be nil by default" do
      RulesEngine::Rule::Definition.new.summary.should be_nil
    end
  end
  
  describe "data" do
    it "should be nil by default" do
      RulesEngine::Rule::Definition.new.data.should be_nil
    end
  end
  
  describe "expected_outcomes" do
    it "should be set the default as NEXT" do
      RulesEngine::Rule::Definition.new.expected_outcomes.should be_instance_of(Array)
      RulesEngine::Rule::Definition.new.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::NEXT
      RulesEngine::Rule::Definition.new.expected_outcomes[0][:workflow_code].should be_nil
    end
  end
  
  describe "valid?" do
    it "should be valid by default" do
      MockRule.new.valid?.should be_true
    end    
  end

  describe "errors" do
    it "should be a hash" do
      RulesEngine::Rule::Definition.new.errors.should be_instance_of(Hash)
      rule = RulesEngine::Rule::Definition.new 
    end    
  end

  it "should have the helper function 'after_add_to_workflow' to tell the rule has been added to a workflow" do
    RulesEngine::Rule::Definition.new.methods.should include("after_add_to_workflow")
  end

  it "should have the helper function 'before_remove_from_workflow' to tell the rule is about to be removed from a workflow" do
    RulesEngine::Rule::Definition.new.methods.should include("before_remove_from_workflow")
  end
  
  describe "processing a rule" do
    it "should return a rule_outcome" do
      MockRule.new.process(101, {}).should be_instance_of(RulesEngine::Rule::Outcome)
    end

    it "should set the outcome to NEXT by default" do
      MockRule.new.process(101, {}).outcome.should == RulesEngine::Rule::Outcome::NEXT
    end        
  end
  
end
