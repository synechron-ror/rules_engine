require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRuleOutcome do
  def valid_attributes
    {
      :outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT
    }
  end
  
  it "should be valid with valid attributes" do
    ReRuleOutcome.new(valid_attributes).should be_valid
  end
  
  should_validate_presence_of :outcome

  describe "START PIPELINE" do
    it "should be invalid when the outcome pipeline code is blank" do
      re_rule_outcome = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      re_rule_outcome.should_not be_valid
      re_rule_outcome.errors.on(:pipeline_code).should_not be_blank
    end      

    it "should be valid when outcome pipeline code is present" do
      re_rule_outcome = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "mock code")
      re_rule_outcome.should be_valid
    end      
  end

  describe "copying the details from another rule outcome" do
    
    %W(pipeline_code).each do |key|
      it "should copy the attribute #{key}" do
        src = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.copy!(src)
        dest.read_attribute(key).should == "mock source value"
      end
    end

    %W(outcome).each do |key|
      it "should copy the attribute #{key}" do
        src = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => 101))
        dest = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => 202))
        dest.copy!(src)
        dest.read_attribute(key).should == 101
      end
    end
  end

  describe "comparing rule outcomes" do
    it "should be equal if the attributes are equal" do
      src = ReRuleOutcome.new(valid_attributes)
      dest = ReRuleOutcome.new(valid_attributes)
      dest.equals?(src).should be_true
    end
    
    %W(outcome).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => 101))
        dest = ReRuleOutcome.new(valid_attributes.merge(key.to_sym => 202))
        dest.equals?(src).should be_false
      end
    end
    
    it "should not be equal if the outcome is OUTCOME_START_PIPELINE and pipeline_code are different" do
      src = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "value 1")
      dest = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "value 2")
      dest.equals?(src).should be_false
    end
    
  end
  
  describe "verify the rule outcome" do
    it "should be nil if the outcome is OUTCOME_NEXT" do
      ReRuleOutcome.new(valid_attributes.merge(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)).verify.should be_nil
    end

    it "should be nil if the outcome is OUTCOME_STOP_SUCCESS" do
      ReRuleOutcome.new(valid_attributes.merge(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)).verify.should be_nil
    end

    it "should be nil if the outcome is OUTCOME_STOP_FAILURE" do
      ReRuleOutcome.new(valid_attributes.merge(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)).verify.should be_nil
    end

    it "should be valid if the outcome is OUTCOME_START_PIPELINE and the pipleine exists" do
      RePipeline.should_receive(:find).with(:first, {:conditions=>["code = ?", "value 2"]}).and_return(true)
      ReRuleOutcome.new(valid_attributes.merge(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "value 2")).verify.should be_nil
    end

    it "should be invalid if the outcome is OUTCOME_START_PIPELINE and the pipleine does not exist" do
      RePipeline.should_receive(:find).with(:first, {:conditions=>["code = ?", "value 2"]}).and_return(nil)
      ReRuleOutcome.new(valid_attributes.merge(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "value 2")).verify.should == "outcome pipeline missing"
    end
  end
  
end
