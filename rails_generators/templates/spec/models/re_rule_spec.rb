require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRule do
  def valid_attributes
    {
      :rule_class_name => "MockRuleClass",
      :title => "Mock Title",      
      :summary => "Mock Summary",
      :data => "Lots Of Data"
    }
  end
  
  before(:each) do
    @rule = mock("MockRule", :title => "rule title", :summary => "rule summary", :data => "rule data")
    @rule.stub!(:title=)
    @rule.stub!(:summary=)
    @rule.stub!(:data=)
    @rule.stub!(:after_add_to_pipeline)
    @rule.stub!(:before_remove_from_pipeline)
    @rule.stub!(:expected_outcomes).and_return([])
    @rule.stub!(:valid?).and_return(true)
    @rule_class = mock("MockRuleClass")
    @rule_class.stub!(:new).and_return(@rule)      
    RulesEngine::Discovery.stub!(:rule_class).and_return(@rule_class)
  end
  
  it "should be valid with valid attributes" do
    ReRule.new(valid_attributes).should be_valid
  end

  should_have_many :re_rule_expected_outcomes
  should_have_many :re_job_audits
  
  should_validate_presence_of :rule_class_name

  describe "validate the rule" do
    it "should be false if the rule class not found" do
      re_rule = ReRule.new(valid_attributes)
      RulesEngine::Discovery.stub!(:rule_class).and_return(nil)
      re_rule.should_not be_valid
      re_rule.should have(1).error_on(:rule_class)
    end
  
    it "should be false if the rule is not valid" do
      re_rule = ReRule.new(valid_attributes)
      @rule.should_receive(:valid?).and_return(false)    
      re_rule.should_not be_valid
      # re_rule.should have(1).error_on(:rule)      
    end
  end
    
    
  describe "copying the rule" do    
    
    %W(rule_class_name title summary data).each do |key|
      it "should copy the attribute #{key}" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.copy!(src)
        dest.read_attribute(key).should == "mock source value"
      end
    end
  
    %W(position).each do |key|
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
      
      src_outcome = mock_model(ReRuleExpectedOutcome)
      dest_outcome = mock_model(ReRuleExpectedOutcome )
              
      ReRuleExpectedOutcome.should_receive(:new).and_return(dest_outcome)
      dest_outcome.should_receive(:copy!).with(src_outcome).and_return(dest_outcome)
      
      src.should_receive(:re_rule_expected_outcomes).and_return([src_outcome])
      dest.should_receive(:re_rule_expected_outcomes=).with([dest_outcome])
      
      dest.copy!(src)
    end
  end
  
  describe "comparing rules" do
    it "should be equal if the attributes are equal" do
      src = ReRule.new(valid_attributes)
      dest = ReRule.new(valid_attributes)
      dest.equals?(src).should be_true
    end
    
    %W(rule_class_name title summary data).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.equals?(src).should be_false
      end
    end
  
    %W(position).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = ReRule.new(valid_attributes.merge(key.to_sym => 101))
        dest = ReRule.new(valid_attributes.merge(key.to_sym => 202))
        dest.equals?(src).should be_false
      end
    end
  
    describe "equals rule outcome" do
      before(:each) do
        @re_rule_re_rule_expected_outcome_1 = mock_model(ReRuleExpectedOutcome)
        @re_rule_re_rule_expected_outcome_2 = mock_model(ReRuleExpectedOutcome)
        @re_rule_1 = ReRule.new(valid_attributes)
        @re_rule_2 = ReRule.new(valid_attributes)
        @re_rule_1.stub!(:re_rule_expected_outcomes).and_return([@re_rule_re_rule_expected_outcome_1, @re_rule_re_rule_expected_outcome_2])
        @re_rule_2.stub!(:re_rule_expected_outcomes).and_return([@re_rule_re_rule_expected_outcome_1, @re_rule_re_rule_expected_outcome_2])
        
      end
      it "should not compare the outcomes if the the number is different" do
        @re_rule_2.stub!(:re_rule_expected_outcomes).and_return([@re_rule_re_rule_expected_outcome_1])
        
        @re_rule_re_rule_expected_outcome_1.should_not_receive(:equals?)
        @re_rule_re_rule_expected_outcome_2.should_not_receive(:equals?)
      
        @re_rule_1.equals?(@re_rule_2)
      end
    
      it "should check the equals status of each rule outcome" do
        @re_rule_re_rule_expected_outcome_1.should_receive(:equals?).with(@re_rule_re_rule_expected_outcome_1).and_return(true)
        @re_rule_re_rule_expected_outcome_2.should_receive(:equals?).with(@re_rule_re_rule_expected_outcome_2).and_return(true)
      
        @re_rule_1.equals?(@re_rule_2).should be_true
      end
      
      it "should stop on the rule outcome equals error" do
        @re_rule_re_rule_expected_outcome_1.should_receive(:equals?).with(@re_rule_re_rule_expected_outcome_1).and_return(false)
        @re_rule_re_rule_expected_outcome_2.should_not_receive(:equals?)
      
        @re_rule_1.equals?(@re_rule_2).should be_false
      end
    end
  end  
  
  describe "loading a rule" do
    before(:each) do
      @re_rule = ReRule.new(valid_attributes)
    end
  
    it "should return an instance of the rule" do
      @re_rule.rule.should == @rule
    end
    
    it "should load the rule from the discovery" do
      RulesEngine::Discovery.should_receive(:rule_class).with("MockRuleClass")
      @re_rule.rule
    end
  
    it "should only load the rule once" do
      RulesEngine::Discovery.should_receive(:rule_class).once
      @re_rule.rule.should == @rule
      @re_rule.rule.should == @rule
    end
  
    it "should return nil if the rule class not found" do
      RulesEngine::Discovery.should_receive(:rule_class).with("MockRuleClass").and_return(nil)
      @re_rule.rule.should be_nil
    end
  
    it "should create a new instance of the rule class" do
      @rule_class.should_receive(:new)
      @re_rule.rule
    end
  
    it "should set the rule data with the model data attribute" do
      @rule.should_receive(:data=).with("Lots Of Data")
      @re_rule.rule
    end
  end
  
  describe "setting the rule attributes" do
    it "should raise an error if the rule does not exist" do
      re_rule = ReRule.new(valid_attributes)
      RulesEngine::Discovery.should_receive(:rule_class).with("MockRuleClass").and_return(nil)
      lambda { re_rule.rule_attributes={} }.should raise_error('rule class not found')
    end
    
    it "should pass the parameters to the rule" do
      re_rule = ReRule.new(valid_attributes)
      @rule.should_receive("attributes=").with({:mock => "param"})
      re_rule.rule_attributes = {:mock => "param"}
    end    
  end
    
  describe "saving a re_rule" do
    it "should fail if the rule does not exist" do
      re_rule = ReRule.new(valid_attributes)
      re_rule.should_receive(:rule).and_return(nil)
      re_rule.save.should == false
    end
  
    describe "a valid rule" do
      before(:each) do
        @re_rule = ReRule.new(valid_attributes)
        @re_rule.stub(:rule).and_return(@rule)
      end

      it "should be successful" do
        @re_rule.save.should == true
      end
  
      it "should set the re_rule title to the title generated by the rule" do
        @re_rule.save
        @re_rule.title.should == "rule title"      
      end
  
      it "should set the re_rule summary to the summary generated by the rule" do
        @re_rule.save
        @re_rule.summary.should == "rule summary"      
      end
      
      it "should set the re_rule data to the data generated by the rule" do
        @re_rule.save
        @re_rule.data.should == "rule data"      
      end      
      
      it "should set the expected outcomes to the expected outcomes generated by the rule" do
        re_rule_expected_outcome = ReRuleExpectedOutcome.new
        ReRuleExpectedOutcome.should_receive(:new).with(:outcome => 101, :pipeline_code => "one").and_return(re_rule_expected_outcome)
        ReRuleExpectedOutcome.should_receive(:new).with(:outcome => 202, :pipeline_code => "two").and_return(re_rule_expected_outcome)
        @rule.stub(:expected_outcomes).and_return([{:outcome => 101, :pipeline_code => "one"}, {:outcome => 202, :pipeline_code => "two"}])
        @re_rule.save
        @re_rule.re_rule_expected_outcomes.should == [re_rule_expected_outcome, re_rule_expected_outcome]
      end      
    end    
  end
  
  describe "after saving a re_rule" do
    it "should notify the rule" do
      @re_rule = ReRule.new(valid_attributes)
      @re_pipeline_id = nil
      @re_rule_id = nil
      @rule.should_receive(:after_add_to_pipeline) do |re_pipeline_id, re_rule_id|
        @re_pipeline_id = re_pipeline_id
        @re_rule_id = re_rule_id
      end
      @re_rule.save
      @re_rule.re_pipeline_id.should == @re_pipeline_id
      @re_rule.id.should == @re_rule_id
    end  
  end

  describe "before destroying a re_rule" do
    it "should notify the rule" do
      @re_rule = ReRule.create(valid_attributes)
      @rule.should_receive(:before_remove_from_pipeline).with(@re_rule.re_pipeline_id, @re_rule.id)
      @re_rule.destroy
    end  
  end
  
  describe "rule outcomes available" do
    before(:each) do
      @re_rule = ReRule.new      
    end
    
    it "should return the first outcome that is a OUTCOME_NEXT" do
      outcome_1 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)
      outcome_2 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT)
      @re_rule.re_rule_expected_outcomes << outcome_1
      @re_rule.re_rule_expected_outcomes << outcome_2
      @re_rule.re_rule_expected_outcome_next.should == outcome_1
    end
  
    it "should return the first outcome that is a OUTCOME_STOP_SUCCESS" do
      outcome_1 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
      outcome_2 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS)
      @re_rule.re_rule_expected_outcomes << outcome_1
      @re_rule.re_rule_expected_outcomes << outcome_2
      @re_rule.re_rule_expected_outcome_success.should == outcome_1
    end
  
    it "should return the first outcome that is a OUTCOME_STOP_FAILURE" do
      outcome_1 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
      outcome_2 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE)
      @re_rule.re_rule_expected_outcomes << outcome_1
      @re_rule.re_rule_expected_outcomes << outcome_2
      @re_rule.re_rule_expected_outcome_failure.should == outcome_1
    end
  
    it "should return all outcomes that are a OUTCOME_START_PIPELINE" do
      outcome_1 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      outcome_2 = ReRuleExpectedOutcome.new(:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      @re_rule.re_rule_expected_outcomes << outcome_1
      @re_rule.re_rule_expected_outcomes << outcome_2
      @re_rule.re_rule_expected_outcomes_start_pipeline.should == [outcome_1, outcome_2]
    end
  end
  
  describe "checking for rule errors" do
    before(:each) do
      @rule = mock("Rule", :valid? => true)
      
      @re_rule = ReRule.new(valid_attributes)
      @re_rule.stub!(:rule).and_return(@rule)
    end
    
    it "should return '[title] class [class] invalid' if the rule is missing" do
      @re_rule.should_receive(:rule).and_return(nil)
      @re_rule.rule_error.should == "Mock Title class MockRuleClass invalid"
    end
    
    it "should ignore outcomes where the pipeline_code is nil" do
      re_rule_expected_outcome = mock_model(ReRuleExpectedOutcome, :pipeline_code => nil)
      @re_rule.stub!(:re_rule_expected_outcomes).and_return([re_rule_expected_outcome])
      @re_rule.rule_error.should be_nil
    end

    it "should validate the pipeline is present and activated" do
      re_rule_expected_outcome = mock_model(ReRuleExpectedOutcome, :pipeline_code => "mock_pipeline_code", :outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      RePipeline.should_receive(:find_by_code).and_return(mock("RePipeline", :pipeline_error => nil))      
      @re_rule.stub!(:re_rule_expected_outcomes).and_return([re_rule_expected_outcome])
      @re_rule.rule_error.should be_nil
    end
      
    it "should return '[pipeline_code] missing' if the required pipeline is missing" do
      re_rule_expected_outcome = mock_model(ReRuleExpectedOutcome, :pipeline_code => "mock_pipeline_code", :outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      RePipeline.should_receive(:find_by_code).and_return(nil)
      @re_rule.stub!(:re_rule_expected_outcomes).and_return([re_rule_expected_outcome])
      @re_rule.rule_error.should == "mock_pipeline_code missing"
    end
    
    it "should return '[pipeline_code] invalid' if the required pipeline has errors" do
      re_rule_expected_outcome = mock_model(ReRuleExpectedOutcome, :pipeline_code => "mock_pipeline_code", :outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE)
      RePipeline.should_receive(:find_by_code).and_return(mock("RePipeline", :pipeline_error => "pipeline error"))      
      @re_rule.stub!(:re_rule_expected_outcomes).and_return([re_rule_expected_outcome])
      @re_rule.rule_error.should == "mock_pipeline_code invalid"
    end
    
  end
  
  describe "moving items in a list" do
    it "should move a rule down in the list" do
      re_pipeline = RePipelineBase.create!(:code => "AA-MOCK",:title => "Mock Title")

      re_rule_1 = ReRule.new(valid_attributes)
      re_rule_2 = ReRule.new(valid_attributes)
      re_pipeline.re_rules << re_rule_1
      re_pipeline.re_rules << re_rule_2
      
      re_pipeline.reload    
      
      re_pipeline.re_rules.should == [re_rule_1, re_rule_2]
      re_pipeline.re_rules[1].move_higher
      re_pipeline.reload    
  
      re_pipeline.re_rules.should == [re_rule_2, re_rule_1]
    end
  end    
end
