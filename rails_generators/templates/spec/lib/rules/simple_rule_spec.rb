require File.dirname(__FILE__) + '/../../spec_helper'

describe <%=rule_class%>Rule do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Valid Title',
      :<%=rule_name%>_description => 'Valid Description'
    }
  end
  
  def valid_json_data
    '["Valid Title", "Valid Description"]'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("<%=rule_class%>Rule").should == <%=rule_class%>Rule
  end

  describe "the expected class options" do    
    it "should be in the '<%=rule_class%>' group" do
      <%=rule_class%>Rule.options[:group].should == "<%=rule_class%>"
    end
    
    it "should have the diplay name of '<%=rule_class%>'" do
      <%=rule_class%>Rule.options[:display_name].should == "<%=rule_class%>"
    end

    it "should have the help template of '/re_rule_definitions/<%=rule_name%>_rule/help'" do
      <%=rule_class%>Rule.options[:help_partial].should == '/re_rule_definitions/<%=rule_name%>_rule/help'
    end

    it "should have the new template of '/re_rule_definitions/<%=rule_name%>_rule/new'" do
      <%=rule_class%>Rule.options[:new_partial].should == '/re_rule_definitions/<%=rule_name%>_rule/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/<%=rule_name%>_rule/edit'" do
      <%=rule_class%>Rule.options[:edit_partial].should == '/re_rule_definitions/<%=rule_name%>_rule/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new
      @<%=rule_name%>_rule.data = valid_json_data
    end  
    
    describe "the data is valid" do
      it "should be valid" do
        @<%=rule_name%>_rule.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>_rule.title.should == "Valid Title"        
      end

      it "should set the description" do
        @<%=rule_name%>_rule.description.should == "Valid Description"        
      end
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>_rule.title.should_not be_nil
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.title.should be_nil
      end

      it "should set the description to nil" do
        @<%=rule_name%>_rule.title.should_not be_nil
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.description.should be_nil
      end
    end
  end
  
  describe "the summary" do
    it "should be the rule description" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:description).and_return("mock description")
      <%=rule_name%>_rule.summary.should == "mock description"
    end
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:title).and_return("mock title")
      <%=rule_name%>_rule.should_receive(:description).and_return("mock description")
      <%=rule_name%>_rule.data.should == '["mock title","mock description"]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be outcome next" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new
    end  
    
    it "should be valid with valid attributes" do
      @<%=rule_name%>_rule.attributes = valid_attributes
      @<%=rule_name%>_rule.should be_valid
    end            
  
    describe "setting the <%=rule_name%>_title" do
      it "should set the title" do
        @<%=rule_name%>_rule.attributes = valid_attributes
        @<%=rule_name%>_rule.title.should == 'Valid Title'
      end            
    
      it "should not be valid if the '<%=rule_name%>_title' attribute is missing" do
        @<%=rule_name%>_rule.attributes = valid_attributes.except(:<%=rule_name%>_title)
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_title)
      end            
    
      it "should not be valid if the '<%=rule_name%>_title' attribute is blank" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_title => "")
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_title)
      end                
    end

    describe "setting the <%=rule_name%>_description" do
      it "should set the title" do
        @<%=rule_name%>_rule.attributes = valid_attributes
        @<%=rule_name%>_rule.description.should == 'Valid Description'
      end            
    
      it "should not be valid if the '<%=rule_name%>_description' attribute is missing" do
        @<%=rule_name%>_rule.attributes = valid_attributes.except(:<%=rule_name%>_description)
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_description)
      end            
    
      it "should not be valid if the '<%=rule_name%>_description' attribute is blank" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_description => "")
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_description)
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
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new

      @job = mock("job")
      @job.stub!(:audit)
    end
    
    it "should do nothing" do
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new
      @<%=rule_name%>_rule.process(@job, {}).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    end        
  end
end
