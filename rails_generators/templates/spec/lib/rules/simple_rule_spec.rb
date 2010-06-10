require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleRule do

  def valid_attributes
    {
      :simple_title => 'Valid Title'
    }
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("SimpleRule").should == SimpleRule
  end

  describe "the expected class options" do
    
    it "should be in the 'Sample Rules' group" do
      SimpleRule.options[:group].should == "Sample Rules"
    end
    
    it "should have the diplay name of 'Simple Rule'" do
      SimpleRule.options[:display_name].should == "Simple Rule"
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
  
  describe "setting the rule attributes" do
    before(:each) do
      @simple_rule = SimpleRule.new
    end  
    
    it "should be valid with valid attributes" do
      @simple_rule.attributes = valid_attributes
      @simple_rule.verify.should be_nil
    end            

    it "should set the title" do
      @simple_rule.attributes = valid_attributes
      @simple_rule.title.should == 'Valid Simple Title'
    end            
    
    it "should not be valid if the 'simple_title' attribute is missing" do
      @simple_rule.attributes = valid_attributes.except(:simple_title)
      @simple_rule.verify.should == "Title required"
    end            
    
    it "should not be valid if the 'simple_title' attribute is blank" do
      @simple_rule.attributes = valid_attributes.merge(:simple_title => "")
      @simple_rule.verify.should == "Title required"
    end                
  end

  # describe "loading a rule from an re_rule model" do
  #   before(:each) do
  #     @simple_rule = SimpleRule.new
  #     @re_rule = mock_model(ReRule, :title => "Mock Model Rule Title")
  #   end
  #   
  #   it "should set the title from the model" do
  #     @simple_rule.load(@re_rule)
  #     @simple_rule.title.should == "Mock Model Rule Title"
  #   end        
  # 
  #   it "should be successfull with a successful model" do
  #     @simple_rule.load(@re_rule).should == true
  #   end                
  # end
  # 
  # describe "saving a rule to an re_rule model" do
  #   before(:each) do
  #     @simple_rule = SimpleRule.new
  #     @simple_rule.attributes = valid_attributes
  #     @re_rule = mock_model(ReRule, :rule_class_name => true)
  #   end
  # 
  #   it "should be successfull with a valid rule" do
  #     @simple_rule.save(@re_rule).should == true
  #   end                
  #   
  #   it "should save the title to the model" do
  #     @re_rule.should_recieve(:title=).with("Valid Simple Title")
  #     @simple_rule.save(@re_rule)
  #   end        
  # end
  
end
