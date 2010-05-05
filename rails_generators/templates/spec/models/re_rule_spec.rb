require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRule do
  def valid_attributes
    {
      :title => "Mock Title",      
      :rule_class_name => "MockRuleClass",
      :summary => "Mock Summary",
      :data_version => 0,
      :data => "Lots Of Data"
    }
  end
  
  it "should be valid with valid attributes" do
    ReRule.new(valid_attributes).should be_valid
  end

  should_have_many :re_rule_outcomes
  should_have_many :re_job_audits
  
  should_validate_presence_of :title
  should_validate_presence_of :rule_class_name
  should_validate_presence_of :summary
  should_validate_presence_of :data_version
  should_validate_presence_of :data
  
  describe "copying the rule" do
    
    %W(title rule_class_name summary data error).each do |key|
      it "should copy the attribute #{key}" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.copy!(src)
        dest.read_attribute(key).should == "mock source value"
      end
    end

    %W(position data_version).each do |key|
      it "should copy the attribute #{key}" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => 101))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => 202))
        dest.copy!(src)
        dest.read_attribute(key).should == 101
      end
    end
    
    it "should copy the rule outcomes" do
      src = ReRule.new(valid_attributes)
      dest = ReRule.new(valid_attributes)
      
      src_outcome = mock_model(ReRuleOutcome)
      dest_outcome = mock_model(ReRuleOutcome )
              
      ReRuleOutcome.should_receive(:new).and_return(dest_outcome)
      dest_outcome.should_receive(:copy!).with(src_outcome).and_return(dest_outcome)
      
      src.should_receive(:re_rule_outcomes).and_return([src_outcome])
      dest.should_receive(:re_rule_outcomes=).with([dest_outcome])
      
      dest.copy!(src)
    end
  end

  describe "comparing rules" do
    it "should be equal if the attributes are equal" do
      src = ReRule.new(valid_attributes)
      dest = ReRule.new(valid_attributes)
      dest.equals?(src).should be_true
    end
    
    %W(title rule_class_name summary data).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.equals?(src).should be_false
      end
    end

    %W(position data_version).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => 101))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => 202))
        dest.equals?(src).should be_false
      end
    end

    describe "equals rule outcome" do
      before(:each) do
        @re_rule_re_rule_outcome_1 = mock_model(ReRuleOutcome)
        @re_rule_re_rule_outcome_2 = mock_model(ReRuleOutcome)
        @re_rule_1 = ReRule.new(valid_attributes)
        @re_rule_2 = ReRule.new(valid_attributes)
        @re_rule_1.stub!(:re_rule_outcomes).and_return([@re_rule_re_rule_outcome_1, @re_rule_re_rule_outcome_2])
        @re_rule_2.stub!(:re_rule_outcomes).and_return([@re_rule_re_rule_outcome_1, @re_rule_re_rule_outcome_2])
        
      end
      it "should not compare the outcomes if the the number is different" do
        @re_rule_2.stub!(:re_rule_outcomes).and_return([@re_rule_re_rule_outcome_1])
        
        @re_rule_re_rule_outcome_1.should_not_receive(:equals?)
        @re_rule_re_rule_outcome_2.should_not_receive(:equals?)
      
        @re_rule_1.equals?(@re_rule_2)
      end
    
      it "should check the equals status of each rule outcome" do
        @re_rule_re_rule_outcome_1.should_receive(:equals?).with(@re_rule_re_rule_outcome_1).and_return(true)
        @re_rule_re_rule_outcome_2.should_receive(:equals?).with(@re_rule_re_rule_outcome_2).and_return(true)
      
        @re_rule_1.equals?(@re_rule_2).should be_true
      end
      
      it "should stop on the rule outcome equals error" do
        @re_rule_re_rule_outcome_1.should_receive(:equals?).with(@re_rule_re_rule_outcome_1).and_return(false)
        @re_rule_re_rule_outcome_2.should_not_receive(:equals?)
      
        @re_rule_1.equals?(@re_rule_2).should be_false
      end
    end
  end  

  describe "verify the rule" do
    it "should return the rule_error if not blank" do
      src = ReRule.new(valid_attributes.merge(:error => "mock rule error"))
      src.verify.should_not be_blank
      src.verify.should == "mock rule error"
    end
    
    it "should verify each rule outcome" do
      re_rule_outcome_1 = mock_model(ReRule)
      re_rule_outcome_2 = mock_model(ReRule)
      re_rule = ReRule.new
      re_rule.stub!(:re_rule_outcomes).and_return([re_rule_outcome_1, re_rule_outcome_2])
      
      re_rule_outcome_1.should_receive(:verify).at_least(:once).and_return(nil)
      re_rule_outcome_2.should_receive(:verify).at_least(:once).and_return(nil)
      
      re_rule.verify.should be_nil
    end

    it "should stop on the first verify error" do
      re_rule_outcome_1 = mock_model(ReRule)
      re_rule_outcome_2 = mock_model(ReRule)
      re_rule = ReRule.new
      re_rule.stub!(:re_rule_outcomes).and_return([re_rule_outcome_1, re_rule_outcome_2])
      
      re_rule_outcome_1.should_receive(:verify).at_least(:once).and_return("mock fail error")
      re_rule_outcome_2.should_not_receive(:verify)
      
      re_rule.verify.should == "mock fail error"
    end
  end

  describe "moving items up in a list" do
    it "should move a rule down in the list" do
      base = RePipelineBase.create!(:code => "AA-MOCK",:title => "Mock Title")
      re_rule_1 = ReRule.new(valid_attributes)
      re_rule_2 = ReRule.new(valid_attributes)
      base.re_rules << re_rule_1
      base.re_rules << re_rule_2
      
      base.reload    
      
      base.re_rules.should == [re_rule_1, re_rule_2]
      base.re_rules[1].move_higher
      base.reload    

      base.re_rules.should == [re_rule_2, re_rule_1]
    end
  end
  
  describe "rule outcomes available" do
    before(:each) do
      @re_rule = ReRule.new      
    end
    
    it "should return the first outcome that is a OUTCOME_NEXT" do
      outcome_1 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)
      outcome_2 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)
      @re_rule.re_rule_outcomes << outcome_1
      @re_rule.re_rule_outcomes << outcome_2
      @re_rule.re_rule_outcome_next.should == outcome_1
    end

    it "should return the first outcome that is a OUTCOME_STOP_SUCCESS" do
      outcome_1 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
      outcome_2 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
      @re_rule.re_rule_outcomes << outcome_1
      @re_rule.re_rule_outcomes << outcome_2
      @re_rule.re_rule_outcome_success.should == outcome_1
    end

    it "should return the first outcome that is a OUTCOME_STOP_FAILURE" do
      outcome_1 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
      outcome_2 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
      @re_rule.re_rule_outcomes << outcome_1
      @re_rule.re_rule_outcomes << outcome_2
      @re_rule.re_rule_outcome_failure.should == outcome_1
    end

    it "should return all outcomes that are a OUTCOME_START_PIPELINE" do
      outcome_1 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      outcome_2 = ReRuleOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      @re_rule.re_rule_outcomes << outcome_1
      @re_rule.re_rule_outcomes << outcome_2
      @re_rule.re_rule_outcomes_start_pipeline.should == [outcome_1, outcome_2]
    end
    
  end
end
