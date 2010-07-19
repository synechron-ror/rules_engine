require File.dirname(__FILE__) + '/../../spec_helper'

describe <%=rule_class%> do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Valid Title'
      # :<%=rule_name%>_description => 'Valid Description'
    }
  end
  
  def valid_json_data
    '["Valid Title", "Valid Description"]'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("<%=rule_class%>").should == <%=rule_class%>
  end

  describe "the expected class options" do    
    it "should be in the 'General' group" do
      <%=rule_class%>.options[:group].should == "General"
    end
    
    it "should have the diplay name of '<%=rule_class%> Rule'" do
      <%=rule_class%>.options[:display_name].should == "<%=rule_class%> Rule"
    end

    it "should have the help template of '/re_rule_definitions/<%=rule_name%>/help'" do
      <%=rule_class%>.options[:help_partial].should == '/re_rule_definitions/<%=rule_name%>/help'
    end

    it "should have the new template of '/re_rule_definitions/<%=rule_name%>/new'" do
      <%=rule_class%>.options[:new_partial].should == '/re_rule_definitions/<%=rule_name%>/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/<%=rule_name%>/edit'" do
      <%=rule_class%>.options[:edit_partial].should == '/re_rule_definitions/<%=rule_name%>/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @<%=rule_name%> = <%=rule_class%>.new
      @<%=rule_name%>.data = valid_json_data
    end  
    
    describe "the data is valid" do
      it "should be valid" do
        @<%=rule_name%>.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>.title.should == "Valid Title"        
      end

      it "should set the description" do
        @<%=rule_name%>.description.should == "Valid Description"        
      end
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>.title.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.title.should be_nil
      end

      it "should set the description to nil" do
        @<%=rule_name%>.title.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.description.should be_nil
      end
    end
  end
  
  describe "the summary" do
    describe "description set" do
      it "should be the rule description" do
        <%=rule_name%> = <%=rule_class%>.new
        <%=rule_name%>.should_receive(:description).and_return("mock description")
        <%=rule_name%>.summary.should == "mock description"
      end
    end
    describe "description not set" do
      it "should be Does Nothing" do
        <%=rule_name%> = <%=rule_class%>.new
        <%=rule_name%>.should_receive(:description).and_return(nil)
        <%=rule_name%>.summary.should == "Does Nothing"
      end
    end
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%> = <%=rule_class%>.new
      <%=rule_name%>.should_receive(:title).and_return("mock title")
      <%=rule_name%>.should_receive(:description).and_return("mock description")
      <%=rule_name%>.data.should == '["mock title","mock description"]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be outcome next" do
      <%=rule_name%> = <%=rule_class%>.new
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @<%=rule_name%> = <%=rule_class%>.new
    end  
    
    it "should be valid with valid attributes" do
      @<%=rule_name%>.attributes = valid_attributes
      @<%=rule_name%>.should be_valid
    end            
  
    describe "setting the <%=rule_name%>_title" do
      it "should set the title" do
        @<%=rule_name%>.attributes = valid_attributes
        @<%=rule_name%>.title.should == 'Valid Title'
      end            
    
      it "should not be valid if the '<%=rule_name%>_title' attribute is missing" do
        @<%=rule_name%>.attributes = valid_attributes.except(:<%=rule_name%>_title)
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_title)
      end            
    
      it "should not be valid if the '<%=rule_name%>_title' attribute is blank" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_title => "")
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_title)
      end                
    end

    describe "setting the <%=rule_name%>_description" do
      it "should set the description" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_description => 'Valid Description')
        @<%=rule_name%>.description.should == 'Valid Description'
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
    it "should do nothing" do
      @<%=rule_name%> = <%=rule_class%>.new
      @<%=rule_name%>.process(1001, {}).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    end        
  end
end
