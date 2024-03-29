require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReRule do
  def valid_attributes
    {
      :rule_class_name => "MockRuleClass",
      :title => "Rule Title",      
      :summary => "Mock Summary",
      :data => '["Rule Title", ["one", "two"], "start_workflow", "Other Pipeline"]'
    }
  end
  
  before(:each) do
    @rule = mock("MockRule", :title => "rule title", :summary => "rule summary", :data => "rule data")
    @rule.stub!(:title=)
    @rule.stub!(:summary=)
    @rule.stub!(:data=)
    @rule.stub!(:before_create)
    @rule.stub!(:before_update)
    @rule.stub!(:before_destroy)
    @rule.stub!(:valid?).and_return(true)
    @rule_class = mock("MockRuleClass")
    @rule_class.stub!(:new).and_return(@rule)      
    RulesEngine::Discovery.stub!(:rule_class).and_return(@rule_class)
    
    @re_workflow = mock('workflow', :valid? => true)
    @re_workflow.stub!(:code).and_return('mock code')
    @re_workflow.stub!(:changed!)
  end
  
  it "should be valid with valid attributes" do
    ReRule.new(valid_attributes).should be_valid
  end
  
  it "should only be valid with a valid :rule_class_name" do
    rule = ReRule.new(valid_attributes.except(:rule_class_name))
    rule.should_not be_valid
    rule.errors[:rule_class_name].should_not be_blank    
  end
  
  # look into association testing without remarkable
  # it { should belong_to :re_workflow }
  
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
      @rule.should_receive(:data=).with(valid_attributes[:data])
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
    before(:each) do
      @re_rule = ReRule.new(valid_attributes)
      @re_rule.stub!(:re_workflow).and_return(@re_workflow)
    end
    
    it "should fail if the rule does not exist" do
      @re_rule.should_receive(:rule).and_return(nil)
      @re_rule.save.should == false
    end
  
    it "should set tell the workflow the rule has changed" do
      @re_workflow.should_receive(:changed!)
      @re_rule.save
    end
          
    describe "a valid rule" do
      before(:each) do
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
    end    
  end
  
  describe "after creating a re_rule" do
    it "should notify the rule" do
      re_rule = ReRule.new(valid_attributes)
      re_rule.stub!(:re_workflow).and_return(@re_workflow)
  
      @rule.should_receive(:before_create) 
      re_rule.save
    end  
  end
  
  describe "after updating a re_rule" do
    it "should notify the rule" do
      re_rule = ReRule.new(valid_attributes)
      re_rule.stub!(:re_workflow).and_return(@re_workflow)
      re_rule.save
      
      re_rule.title = "New Title"
      @rule.should_receive(:before_update) 
      re_rule.save
    end  
  end
  
  describe "before destroying a re_rule" do
    it "should notify the rule" do
      re_rule = ReRule.new(valid_attributes)
      re_rule.stub!(:re_workflow).and_return(@re_workflow)
  
      @rule.should_receive(:before_destroy)
      re_rule.destroy
    end  
  end
  
  describe "checking for rule errors" do
    before(:each) do
      @rule = mock("Rule")
      @re_rule = ReRule.new(valid_attributes)
    end
    
    it "should return '[title] class [class] invalid' if the rule is missing" do
      @re_rule.should_receive(:rule).and_return(nil)
      @re_rule.rule_error.should == "class MockRuleClass missing"
    end
  
    it "should return 'the rule errors' if the rule has errors" do
      @re_rule.stub!(:rule).and_return(@rule)
      @rule.should_receive(:valid?).and_return(false)
      @rule.should_receive(:errors).and_return(mock('error', :values => ['one', 'two']))
      @re_rule.rule_error.should == "one, two"
    end
  
    it "should return 'nil' if the rule has no errors" do
      @re_rule.stub!(:rule).and_return(@rule)
      @rule.should_receive(:valid?).and_return(true)
      @re_rule.rule_error.should == nil
    end    
  end
  
  describe "moving items in a list" do
    it "should move a rule down in the list" do
      re_workflow = ReWorkflow.create!(:code => "AA-MOCK",:title => "Rule Title")
      
      re_rule_1 = ReRule.new(valid_attributes)
      re_rule_2 = ReRule.new(valid_attributes)
      re_workflow.re_rules << re_rule_1
      re_workflow.re_rules << re_rule_2
      
      re_workflow.reload    
      
      re_workflow.re_rules.should == [re_rule_1, re_rule_2]
      re_workflow.re_rules[1].move_higher
      re_workflow.reload    
  
      re_workflow.re_rules.should == [re_rule_2, re_rule_1]
    end
  end    
  
  describe "publish" do
    it "should convert the rule to a hash" do
      re_rule = ReRule.new(valid_attributes)
      
      publish_data = re_rule.publish
      publish_data["rule_class_name"].should == valid_attributes[:rule_class_name]
      publish_data["title"].should == valid_attributes[:title]
      publish_data["summary"].should == valid_attributes[:summary]
      publish_data["data"].should == valid_attributes[:data]
    end
  end
  
  describe "revert!" do
    it "should return self" do
      re_rule = ReRule.new
      re_rule.revert!({}).should == re_rule
    end
  
    it "should set the rule based on the data" do
      re_rule = ReRule.new
      
      re_rule.revert!({
        "rule_class_name" => 'mock_rule_class_name',
        "title" => 'mock title',
        "summary" => 'mock summary',
        "data" => 'mock data'
      })
      
      re_rule[:rule_class_name].should == 'mock_rule_class_name'
      re_rule[:title].should == 'mock title'
      re_rule[:summary].should == 'mock summary'
      re_rule[:data].should == 'mock data'
    end
  end
end
