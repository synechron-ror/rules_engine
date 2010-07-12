require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRuleExpectedOutcome do
  def valid_attributes
    {
      :outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT
    }
  end
  
  it "should be valid with valid attributes" do
    ReRuleExpectedOutcome.new(valid_attributes).should be_valid
  end
  
  should_validate_presence_of :outcome

  describe "START WORKFLOW" do
    it "should be invalid when the outcome workflow code is blank" do
      re_rule_expected_outcome = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW)
      re_rule_expected_outcome.should_not be_valid
      re_rule_expected_outcome.errors.on(:workflow_code).should_not be_blank
    end      
  
    it "should be valid when outcome workflow code is present" do
      re_rule_expected_outcome = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_WORKFLOW, :workflow_code => "mock code")
      re_rule_expected_outcome.should be_valid
    end      
  end
    
end
