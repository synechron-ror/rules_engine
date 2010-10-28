require File.dirname(__FILE__) + '/../../spec_helper'

def valid_<%=rule_name%>_rule_data
  '["Rule Title", "Rule Description"]'
end
  
describe RulesEngine::Rule::<%=rule_name.camelize%> do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Rule Title',
      :<%=rule_name%>_description => 'Rule Description'
    }
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("RulesEngine::Rule::<%=rule_name.camelize%>").should == RulesEngine::Rule::<%=rule_name.camelize%>
  end

  describe "the expected class options" do    
    it "should be in the 'General' group" do
      RulesEngine::Rule::<%=rule_name.camelize%>.options[:group].should == "General"
    end
    
    it "should have the diplay name of '<%=rule_name.camelize%>'" do
      RulesEngine::Rule::<%=rule_name.camelize%>.options[:display_name].should == "<%=rule_name.camelize%>"
    end

    it "should have the help template of '/re_rules/<%=rule_name%>/help'" do
      RulesEngine::Rule::<%=rule_name.camelize%>.options[:help_partial].should == '/re_rules/<%=rule_name%>/help'
    end

    it "should have the new template of '/re_rules/<%=rule_name%>/new'" do
      RulesEngine::Rule::<%=rule_name.camelize%>.options[:new_partial].should == '/re_rules/<%=rule_name%>/new'
    end

    it "should have the edit view partial template of '/re_rules/<%=rule_name%>/edit'" do
      RulesEngine::Rule::<%=rule_name.camelize%>.options[:edit_partial].should == '/re_rules/<%=rule_name%>/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      @<%=rule_name%>.data = valid_<%=rule_name%>_rule_data
    end  
    
    describe "the data is valid" do
      it "should be valid" do
        @<%=rule_name%>.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>.title.should == "Rule Title"        
      end

      it "should set the description" do
        @<%=rule_name%>.description.should == "Rule Description"        
      end
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>.title.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.title.should be_nil
      end

      # it "should set the description to nil" do
      #   @<%=rule_name%>.description.should_not be_nil
      #   @<%=rule_name%>.data = nil
      #   @<%=rule_name%>.description.should be_nil
      # end
    end
  end
  
  describe "the summary" do
    describe "description not set" do
      it "should be Summary Required" do
        <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
        <%=rule_name%>.summary.should == "Summary Required"
      end
    end
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.should_receive(:title).and_return("mock title")
      <%=rule_name%>.should_receive(:description).and_return("mock description")
      <%=rule_name%>.data.should == '["mock title","mock description"]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be outcome next" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::NEXT
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
    end  
    
    it "should be valid with valid attributes" do
      @<%=rule_name%>.attributes = valid_attributes
      @<%=rule_name%>.should be_valid
    end            
  
    describe "setting the <%=rule_name%>_title" do
      it "should set the title" do
        @<%=rule_name%>.attributes = valid_attributes
        @<%=rule_name%>.title.should == 'Rule Title'
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
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_description => 'Rule Description')
        @<%=rule_name%>.description.should == 'Rule Description'
      end            
    end
  end
  
  describe "before a rule is created" do
    # xit "There is nothing to do here"
  end
  
  describe "before a rule is updated" do
    # xit "There is nothing to do here"
  end
  
  describe "before a rule is destroyed" do
    # xit "There is nothing to do here"
  end
  
  describe "processing the rule" do
    it "should do nothing" do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      @<%=rule_name%>.process(1001, {:plan => "plan"}, {}).outcome.should == RulesEngine::Rule::Outcome::NEXT
    end        
  end
end


describe ReWorkflowRulesController  do
  include RSpec::Rails::ControllerExampleGroup
  
  render_views
  
  describe "RulesEngine::Rule::<%=rule_name.camelize%>" do
  
    before(:each) do
      controller.instance_eval { flash.stub!(:sweep) }

      RulesEngine::Discovery.discover!
        
      controller.stub!(:rules_engine_reader_access_required).and_return(true)
      controller.stub!(:rules_engine_editor_access_required).and_return(true)

      @re_workflow = ReWorkflow.create!(:code => "valid code", :title => 'Valid title')
      ReWorkflow.stub!(:find).and_return(@re_workflow)
    end  
  
    describe "help" do
      it "should assign the <%=rule_name%> rule class" do
        get :help, :re_workflow_id => @re_workflow.id, :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>"
        assigns[:rule_class].should == RulesEngine::Rule::<%=rule_name.camelize%>
      end
    end

    describe "new" do
      it "show the new form" do
        get :new, :re_workflow_id => @re_workflow.id, :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>"
        response.should have_selector("form#re_rule_new_form") do |form|
          form.should have_selector("input#<%=rule_name%>_title")
          # form.should have_selector("input#<%=rule_name%>_description")      
        end  
      end
    end
  
    describe "edit" do
      it "show the edit form" do
        re_rule = ReRule.create!(:re_workflow_id => @re_workflow.id, :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>",
                                  :data => valid_<%=rule_name%>_rule_data)
        ReRule.stub!(:find).and_return(re_rule)
      
        get :edit, :re_workflow_id => @re_workflow.id, :id => 1001, :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>"
        response.should have_selector("form#re_rule_edit_form") do |form|
          form.should have_selector("input#<%=rule_name%>_title", :value => 'Rule Title')     
          # form.should have_selector("input#<%=rule_name%>_description", :value => 'Rule Description')     
        end  
      end
    end
  end
end
