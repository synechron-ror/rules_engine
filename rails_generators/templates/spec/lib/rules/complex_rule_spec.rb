require File.dirname(__FILE__) + '/../spec_helper'

describe ComplexRule do

  def valid_attributes
    {
      :complex_title => 'Valid Title'
    }
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("ComplexRule").should == ComplexRule
  end

  describe "the expected class options" do
    
    it "should be in the 'Sample Rules' group" do
      ComplexRule.options[:group].should == "Sample Rules"
    end
    
    it "should have the diplay name of 'Simple Rule'" do
      ComplexRule.options[:display_name].should == "Complex Rule"
    end

    it "should have the help template of '/re_rule_definitions/complex_rule/help'" do
      ComplexRule.options[:help_partial].should == '/re_rule_definitions/complex_rule/help'
    end

    it "should have the new template of '/re_rule_definitions/complex_rule/new'" do
      ComplexRule.options[:new_partial].should == '/re_rule_definitions/complex_rule/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/complex_rule/edit'" do
      ComplexRule.options[:edit_partial].should == '/re_rule_definitions/complex_rule/edit'
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @complex_rule = ComplexRule.new
    end  
    
    it "should be valid with valid attributes" do
      @complex_rule.attributes = valid_attributes
      @complex_rule.verify.should be_nil
    end            

    it "should set the title" do
      @complex_rule.attributes = valid_attributes
      @complex_rule.title.should == 'Valid Simple Title'
    end            
    
    it "should not be valid if the 'simple_title' attribute is missing" do
      @complex_rule.attributes = valid_attributes.except(:simple_title)
      @complex_rule.verify.should == "Title required"
    end            
    
    it "should not be valid if the 'simple_title' attribute is blank" do
      @complex_rule.attributes = valid_attributes.merge(:simple_title => "")
      @complex_rule.verify.should == "Title required"
    end                
  end

  # describe "loading a rule from an re_rule model" do
  #   before(:each) do
  #     @complex_rule = ComplexRule.new
  #     @re_rule = mock_model(ReRule, :title => "Mock Model Rule Title")
  #   end
  #   
  #   it "should set the title from the model" do
  #     @complex_rule.load(@re_rule)
  #     @complex_rule.title.should == "Mock Model Rule Title"
  #   end        
  # 
  #   it "should be successfull with a successful model" do
  #     @complex_rule.load(@re_rule).should == true
  #   end                
  # end
  # 
  # describe "saving a rule to an re_rule model" do
  #   before(:each) do
  #     @complex_rule = ComplexRule.new
  #     @complex_rule.attributes = valid_attributes
  #     @re_rule = mock_model(ReRule, :rule_class_name => true)
  #   end
  # 
  #   it "should be successfull with a valid rule" do
  #     @complex_rule.save(@re_rule).should == true
  #   end                
  #   
  #   it "should save the title to the model" do
  #     @re_rule.should_recieve(:title=).with("Valid Simple Title")
  #     @complex_rule.save(@re_rule)
  #   end        
  # end
  
end
