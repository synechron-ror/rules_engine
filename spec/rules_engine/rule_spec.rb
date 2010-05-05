require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MockRule < RulesEngine::Rule
end

describe "RulesEngine::Rule" do
  it "should add a class method rule_class" do
    MockRule.methods.should include("rule_class_name")
  end
  
  it "should return the class name as the rule class" do
    MockRule.rule_class_name.should == "MockRule"
  end

  it "should be valid by default" do
    MockRule.new.should be_valid
  end
  
  it "should return an empty array of errors" do
    MockRule.new.errors.should be_empty
    MockRule.new.errors.should be_instance_of(Array)
  end
  
  describe "loading a re_rule" do
    it "should be successful be default" do
      rule = mock('rule')
      MockRule.new.load(rule).should == true
    end
  end

  describe "saveing a re_rule" do
    it "should be successful be default" do
      rule = mock('rule')
      rule.stub!(:rule_class_name=)
      MockRule.new.save(rule).should == true
    end

    it "should set the rule class" do
      rule = mock('rule')
      rule.should_receive(:rule_class_name=).with("MockRule")
      MockRule.new.save(rule).should == true
    end
  end
  
  describe "notifications" do
    it "should call after_create when the re_rule is created" do
      MockRule.new.methods.should include("after_create")
    end

    it "should call after_update when the re_rule is updated" do
      MockRule.new.methods.should include("after_update")
    end

    it "should call before_destroy before  the re_rule is destroyed" do
      MockRule.new.methods.should include("before_destroy")
    end    
  end
  
  describe "processing a rule" do
    it "should return a rule_outcome" do
      MockRule.new.process(1, {}).should be_instance_of(RulesEngine::RuleOutcome)
    end

    it "should set the outcome to OUTCOME_NEXT by default" do
      MockRule.new.process(1, {}).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    end        
  end
  
end
