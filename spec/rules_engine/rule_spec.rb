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

  it "should be able to set the attribute 'data'" do
    RulesEngine::Rule.new.methods.should include("data=")
  end

  it "should be able to get the attribute 'title'" do
    RulesEngine::Rule.new.methods.should include("title")    
  end

  it "should be able to get the attribute 'summary'" do
    RulesEngine::Rule.new.methods.should include("summary")
  end

  it "should be able to get the attribute 'data'" do
    RulesEngine::Rule.new.methods.should include("data")
  end

  it "should be able to get the attribute 'expected_outcomes'" do
    RulesEngine::Rule.new.methods.should include("expected_outcomes")
  end

  it "should be set the default 'expected_outcomes' as NEXT" do
    RulesEngine::Rule.new.expected_outcomes.should be_instance_of(Array)
    RulesEngine::Rule.new.expected_outcomes[0][:outcome].should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    RulesEngine::Rule.new.expected_outcomes[0][:pipeline_code].should be_nil
  end

  describe "valid?" do
    it "should be valid by default" do
      MockRule.new.valid?.should be_true
    end    
  end

  describe "errors" do
    it "should be a hash" do
      RulesEngine::Rule.new.errors.should be_instance_of(Hash)
      rule = RulesEngine::Rule.new 
    end    
  end

  it "should have the helper function 'after_add_to_pipeline' to tell the rule has been added to a pipeline" do
    RulesEngine::Rule.new.methods.should include("after_add_to_pipeline")
  end

  it "should have the helper function 'before_remove_from_pipeline' to tell the rule is about to be removed from a pipeline" do
    RulesEngine::Rule.new.methods.should include("before_remove_from_pipeline")
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
