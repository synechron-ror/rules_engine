require File.dirname(__FILE__) + '/../../spec_helper'

def valid_<%=rule_name%>_rule_data
  '["Rule Title", ["word one", "word two"],"1","start_workflow","Other Workflow"]'
end

describe RulesEngine::Rule::<%=rule_name.camelize%> do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Another Title',
      :<%=rule_name%>_match_words => {
                    "1" => { "word" => 'first word'  },
                    "2" => { "word" => 'second word' }
                  },
      :<%=rule_name%>_match_type => RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_WORD
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
    
    describe "the json data is valid" do
      it "should be valid" do
        @<%=rule_name%>.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>.title.should == "Rule Title"        
      end

      it "should set the match_words" do
        @<%=rule_name%>.match_words.should == ["word one", "word two"]
      end

      it "should set match_type" do
        @<%=rule_name%>.match_type.should == RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_WORD
      end
      
      it "should set the workflow_action" do
        @<%=rule_name%>.workflow_action.should == "start_workflow"
      end

      it "should set the workflow" do
        @<%=rule_name%>.workflow_code.should == "Other Workflow"
      end        
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>.title.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.title.should be_nil
      end
      
      it "should set the match_words to nil" do
        @<%=rule_name%>.match_words.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.match_words.should be_nil
      end

      it "should set match_types to MESSAGE_MATCH_ALL" do
        @<%=rule_name%>.match_type.should_not == false
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.match_type.should == RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_ALL
      end

      it "should se the workflow action to 'next'" do
        @<%=rule_name%>.workflow_action.should_not == 'next'
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.workflow_action.should == 'next'
      end
      
      it "should set the 'workflow' to nil" do
        @<%=rule_name%>.workflow_code.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.workflow_code.should be_nil
      end              
    end
  end
  
  describe "the summary" do
    it "should describe the rule" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.summary.should == "The next action is based on a match being found"
    end
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.should_receive(:title).and_return("mock title")
      <%=rule_name%>.should_receive(:match_words).and_return(["one", "two"])
      <%=rule_name%>.should_receive(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_WORD)
      <%=rule_name%>.should_receive(:workflow_action).and_return("workflow action")
      <%=rule_name%>.should_receive(:workflow_code).and_return("workflow")
      <%=rule_name%>.data.should == '["mock title",["one","two"],"1","workflow action","workflow"]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be next" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.stub!(:workflow_action).and_return('next')
      <%=rule_name%>.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::NEXT
    end
    
    it "should be stop success" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.stub!(:workflow_action).and_return('stop_success')
      <%=rule_name%>.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::STOP_SUCCESS
    end
    
    it "should be stop failure" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.stub!(:workflow_action).and_return('stop_failure')
      <%=rule_name%>.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::STOP_FAILURE      
    end
    
    it "should be start workflow" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.stub!(:workflow_action).and_return('start_workflow')
      <%=rule_name%>.stub!(:workflow_code).and_return('workflow_code')
      <%=rule_name%>.expected_outcomes[0][:outcome].should == RulesEngine::Rule::Outcome::START_WORKFLOW
      <%=rule_name%>.expected_outcomes[0][:title].should == "Start Workflow : workflow_code"
    end
    
    it "should be next be default" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      <%=rule_name%>.stub!(:workflow_action).and_return('this is not valid')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::NEXT]
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
        @<%=rule_name%>.title.should == 'Another Title'
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

    describe "setting the <%=rule_name%>_match_words" do
      it "should set the match_words" do
        @<%=rule_name%>.attributes = valid_attributes
        @<%=rule_name%>.match_words.should == ['first word', 'second word']
      end            
    
      it "should not be valid if the '<%=rule_name%>_match_words' attribute is missing" do
        @<%=rule_name%>.attributes = valid_attributes.except(:<%=rule_name%>_match_words)
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_match_words)      
      end            
    
      it "should not be valid if the '<%=rule_name%>_match_words' is not a hash" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_match_words => "<%=rule_name%> word")
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_match_words)
      end                

      it "should not be valid if the '<%=rule_name%>_match_words' is empty" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_match_words => {})
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_match_words)
      end                
      
      it "should not include parameters that are marked for deletion" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_match_words => {
                                                                              "1" => { "word" => 'first word', "_delete" => '1'  },
                                                                              "2" => { "word" => 'second word' }
                                                                            }         
         )
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.match_words.should == ['second word']
      end
    end

    describe "setting the <%=rule_name%>_match_type" do
      it "should set the match_type" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_match_type => "3")
        @<%=rule_name%>.match_type.should == RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_END_WITH
      end                
    end

    describe "setting the <%=rule_name%>_workflow" do
      it "should set the workflow action" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "mock action")        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow_action.should == 'mock action'
      end

      it "should set the workflow action to 'next' by default" do
        @<%=rule_name%>.attributes = valid_attributes.except(:<%=rule_name%>_workflow_action)        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow_action.should == 'next'
      end

      it "should set the workflow_code" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_code => "mock workflow")        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow_code.should == 'mock workflow'
      end
          
      describe "workflow action is start_workflow" do
        it "should be valid with valid '<%=rule_name%>_workflow'" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow", :<%=rule_name%>_workflow_code => "mock workflow")        
          @<%=rule_name%>.should be_valid
          @<%=rule_name%>.workflow_code.should == 'mock workflow'
        end            
        
        it "should not be valid if the '<%=rule_name%>_workflow' attribute is missing" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow").except(:<%=rule_name%>_workflow_code)        
          @<%=rule_name%>.should_not be_valid
          @<%=rule_name%>.errors.should include(:<%=rule_name%>_workflow_code)
        end            

        it "should not be valid if the '<%=rule_name%>_workflow' attribute is blank" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow", :<%=rule_name%>_workflow_code => "")        
          @<%=rule_name%>.should_not be_valid
          @<%=rule_name%>.errors.should include(:<%=rule_name%>_workflow_code)
        end            
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
    before(:each) do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_name.camelize%>.new
      @<%=rule_name%>.stub!(:match_words).and_return(["found this sentance", "word", "other word"])
    end
    
    it "should do nothing if there is no message" do      
      @<%=rule_name%>.process(1001, {:plan => "plan"}, {:data => "data"}).outcome.should == RulesEngine::Rule::Outcome::NEXT
    end        
  
    describe "no matches found" do
      it "should record the misses" do
        matched_data = {:message => "nothing to see here"}
        @<%=rule_name%>.process(@job, {:plan => "plan"}, matched_data.merge!(:misses => ["none"]))
        matched_data[:misses].should == ["found this sentance", "word", "other word"]
      end
    end    

    describe "MATCH_ALL" do
      before(:each) do
        @<%=rule_name%>.stub!(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_ALL)        
        @matched_data = {:message => "found this sentance"}
      end
      
      it "should record the matches and misses" do
        @<%=rule_name%>.process(@job, {:plan => "plan"}, @matched_data.merge!(:matches => ["none"], :misses => ["none"]))
        @matched_data[:matches].should == ["found this sentance"]
        @matched_data[:misses].should == ["word", "other word"]
      end
    end

    describe "MATCH_WORD" do
      before(:each) do
        @<%=rule_name%>.stub!(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_WORD)        
        @matched_data = {:message => "found this word in a sentance"}
      end
      
      it "should record the matches and misses" do
        @<%=rule_name%>.process(@job, {:plan => "plan"}, @matched_data.merge!(:matches => ["none"], :misses => ["none"]))
        @matched_data[:matches].should == ["word"]
        @matched_data[:misses].should == ["found this sentance", "other word"]
      end
    end

    describe "MATCH_BEGIN_WITH" do
      before(:each) do
        @<%=rule_name%>.stub!(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_BEGIN_WITH)        
        @matched_data = {:message => "word found in a other word sentance"}
      end
      
      it "should record the matches and misses" do
        @<%=rule_name%>.process(@job, {:plan => "plan"}, @matched_data.merge!(:matches => ["none"], :misses => ["none"]))
        @matched_data[:matches].should == ["word"]
        @matched_data[:misses].should == ["found this sentance", "other word"]
      end
    end

    describe "MATCH_END_WITH" do
      before(:each) do
        @<%=rule_name%>.stub!(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_END_WITH)
        @matched_data = {:message => "found in a other word sentance word"}
      end
      
      it "should record the matches and misses" do
        @<%=rule_name%>.process(@job, {:plan => "plan"}, @matched_data.merge!(:matches => ["none"], :misses => ["none"]))
        @matched_data[:matches].should == ["word"]
        @matched_data[:misses].should == ["found this sentance", "other word"]
      end
    end


    describe "matching workflow actions" do
      before(:each) do
        @<%=rule_name%>.stub!(:match_type).and_return(RulesEngine::Rule::<%=rule_name.camelize%>::MESSAGE_MATCH_ALL)        
        @matched_data = {:message => "found this sentance"}
      end
      
      it "should return next" do
        @<%=rule_name%>.should_receive(:workflow_action).and_return('next')
        @<%=rule_name%>.process(1001, {:plan => "plan"}, @matched_data).outcome.should == RulesEngine::Rule::Outcome::NEXT
      end

      it "should return stop_success" do
        @<%=rule_name%>.should_receive(:workflow_action).and_return('stop_success')
        @<%=rule_name%>.process(1001, {:plan => "plan"}, @matched_data).outcome.should == RulesEngine::Rule::Outcome::STOP_SUCCESS
      end

      it "should return stop_failure" do
        @<%=rule_name%>.should_receive(:workflow_action).and_return('stop_failure')
        @<%=rule_name%>.process(1001, {:plan => "plan"}, @matched_data).outcome.should == RulesEngine::Rule::Outcome::STOP_FAILURE
      end
      
      it "should return start workflow with the workflow_code" do
        @<%=rule_name%>.should_receive(:workflow_action).and_return('start_workflow')
        @<%=rule_name%>.should_receive(:workflow_code).and_return('mock_workflow')
        <%=rule_name%>_outcome = @<%=rule_name%>.process(1001, {:plan => "plan"}, @matched_data)
        <%=rule_name%>_outcome.outcome.should == RulesEngine::Rule::Outcome::START_WORKFLOW
        <%=rule_name%>_outcome.workflow_code.should == "mock_workflow"
      end        
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

      @re_workflow = ReWorkflow.create!(:code => "valid code", :title => 'Valid title', :description => 'Test Workflow')
      ReWorkflow.stub!(:find).and_return(@re_workflow)
    end  
  
    describe "<%=rule_name%> rule help" do
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
          form.should have_selector("input#<%=rule_name%>_match_words_0_word")
          form.should have_selector("select#<%=rule_name%>_workflow_action") do |selector|
            selector.should have_selector("option", :content => "Continue Next") do |option|
              option.attr("selected").should_not be_nil
              option.attr("selected").value.should == "selected"
            end
            selector.should have_selector("option", :content => "Stop Success")
            selector.should have_selector("option", :content => "Stop Failure")
            selector.should have_selector("option", :content => "Start another Workflow")
          end  
          form.should have_selector("input#<%=rule_name%>_workflow_code")
        end  
      end
    end

    describe "edit" do
      it "show the edit form" do
        re_rule = ReRule.create!(:re_workflow_id => @re_workflow.id, 
                                  :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>",
                                  :data => valid_<%=rule_name%>_rule_data)
        ReRule.stub!(:find).and_return(re_rule)
      
        get :edit, :re_workflow_id => @re_workflow.id, :id => 1001, :rule_class_name => "RulesEngine::Rule::<%=rule_name.camelize%>"
        response.should have_selector("form#re_rule_edit_form") do |form|
          form.should have_selector("input#<%=rule_name%>_title", :value => 'Rule Title')     
          form.should have_selector("input#<%=rule_name%>_match_words_0_word", :value => 'word one')
          form.should have_selector("input#<%=rule_name%>_match_words_1_word", :value => 'word two')
          form.should have_selector("select#<%=rule_name%>_workflow_action") do |selector|
            selector.should have_selector("option", :content => "Continue Next")
            selector.should have_selector("option", :content => "Stop Success")
            selector.should have_selector("option", :content => "Stop Failure")
            selector.should have_selector("option", :content => "Start another Workflow") do |option|
              option.attr("selected").should_not be_nil
              option.attr("selected").value.should == "selected"
            end
          end  
          form.should have_selector("input#<%=rule_name%>_workflow_code", :value => 'Other Workflow')
        end  
      end
    end
  end
end
