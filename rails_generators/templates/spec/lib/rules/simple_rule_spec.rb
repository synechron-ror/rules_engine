require File.dirname(__FILE__) + '/../../spec_helper'

describe SimpleRule do

  def valid_attributes
    {
      :simple_title => 'Valid Title'
    }
  end
  
  def valid_data
    'Rule Title'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("SimpleRule").should == SimpleRule
  end

  describe "the expected class options" do    
    it "should be in the 'Sample Rules' group" do
      SimpleRule.options[:group].should == "Sample Rules"
    end
    
    it "should have the diplay name of 'Does Nothing'" do
      SimpleRule.options[:display_name].should == "Does Nothing"
    end

    it "should have the help template of '/re_rule_definitions/simple_rule/help'" do
      SimpleRule.options[:help_partial].should == '/re_rule_definitions/simple_rule/help'
    end

    it "should have the new template of '/re_rule_definitions/simple_rule/new'" do
      SimpleRule.options[:new_partial].should == '/re_rule_definitions/simple_rule/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/simple_rule/edit'" do
      SimpleRule.options[:edit_partial].should == '/re_rule_definitions/simple_rule/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @simple_rule = SimpleRule.new
      @simple_rule.data = valid_data
    end  
    
    describe "the data is valid" do
      it "should be valid" do
        @simple_rule.should be_valid
      end
            
      it "should set the title" do
        @simple_rule.title.should == "Rule Title"        
      end
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @simple_rule.title.should_not be_nil
        @simple_rule.data = nil
        @simple_rule.title.should be_nil
      end
    end
  end
  
  describe "the summary" do
    it "should be include the rule title" do
      simple_rule = SimpleRule.new
      simple_rule.should_receive(:title).and_return("mock title")
      simple_rule.summary.should == "Does Nothing, but called mock title"
    end
  end

  describe "the data" do
    it "should be the title" do
      simple_rule = SimpleRule.new
      simple_rule.should_receive(:title).and_return("mock title")
      simple_rule.data.should == 'mock title'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be empty" do
      simple_rule = SimpleRule.new
      simple_rule.expected_outcomes.should == []
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @simple_rule = SimpleRule.new
    end  
    
    it "should be valid with valid attributes" do
      @simple_rule.attributes = valid_attributes
      @simple_rule.should be_valid
    end            
  
    describe "setting the simple_title" do
      it "should set the title" do
        @simple_rule.attributes = valid_attributes
        @simple_rule.title.should == 'Valid Title'
      end            
    
      it "should not be valid if the 'simple_title' attribute is missing" do
        @simple_rule.attributes = valid_attributes.except(:simple_title)
        @simple_rule.should_not be_valid
        @simple_rule.errors.should include(:simple_title)
      end            
    
      it "should not be valid if the 'simple_title' attribute is blank" do
        @simple_rule.attributes = valid_attributes.merge(:simple_title => "")
        @simple_rule.should_not be_valid
        @simple_rule.errors.should include(:simple_title)
      end                
    end
  end
  
  describe "after a rule is created" do
    # xit "There is nothing to do here"
  end
  
  describe "after a rule is created" do
    # xit "There is nothing to do here"
  end
  
  describe "processing the rule" do
    before(:each) do
      @simple_rule = SimpleRule.new
    end
    
    it "should do nothing" do
      @simple_rule = SimpleRule.new
      @simple_rule.process(101, {}).should be_nil
    end        
  end
end
