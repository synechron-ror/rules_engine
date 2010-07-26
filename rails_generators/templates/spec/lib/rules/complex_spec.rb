require File.dirname(__FILE__) + '/../../spec_helper'

def valid_<%=rule_name%>_rule_data
  '["Rule Title", ["word one", "word two"], "start_workflow", "Other Workflow"]'
end

describe RulesEngine::Rule::<%=rule_class%> do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Another Title',
      :<%=rule_name%>_words => {
                    "1" => { "word" => 'first word'  },
                    "2" => { "word" => 'second word' }
                  }
    }
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("RulesEngine::Rule::<%=rule_class%>").should == RulesEngine::Rule::<%=rule_class%>
  end

  describe "the expected class options" do    
    it "should be in the 'General' group" do
      RulesEngine::Rule::<%=rule_class%>.options[:group].should == "General"
    end
    
    it "should have the diplay name of '<%=rule_class%>'" do
      RulesEngine::Rule::<%=rule_class%>.options[:display_name].should == "<%=rule_class%>"
    end

    it "should have the help template of '/re_rule_definitions/<%=rule_name%>/help'" do
      RulesEngine::Rule::<%=rule_class%>.options[:help_partial].should == '/re_rule_definitions/<%=rule_name%>/help'
    end

    it "should have the new template of '/re_rule_definitions/<%=rule_name%>/new'" do
      RulesEngine::Rule::<%=rule_class%>.options[:new_partial].should == '/re_rule_definitions/<%=rule_name%>/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/<%=rule_name%>/edit'" do
      RulesEngine::Rule::<%=rule_class%>.options[:edit_partial].should == '/re_rule_definitions/<%=rule_name%>/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      @<%=rule_name%>.data = valid_<%=rule_name%>_rule_data
    end  
    
    describe "the json data is valid" do
      it "should be valid" do
        @<%=rule_name%>.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>.title.should == "Rule Title"        
      end

      it "should set the words" do
        @<%=rule_name%>.words.should == ["word one", "word two"]
      end

      it "should set the workflow_action" do
        @<%=rule_name%>.workflow_action.should == "start_workflow"
      end

      it "should set the workflow" do
        @<%=rule_name%>.workflow.should == "Other Workflow"
      end        
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>.title.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.title.should be_nil
      end
      
      it "should set the words to nil" do
        @<%=rule_name%>.words.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.words.should be_nil
      end

      it "should se the workflow action to 'continue'" do
        @<%=rule_name%>.workflow_action.should_not == 'continue'
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.workflow_action.should == 'continue'
      end
      
      it "should set the 'workflow' to nil" do
        @<%=rule_name%>.workflow.should_not be_nil
        @<%=rule_name%>.data = nil
        @<%=rule_name%>.workflow.should be_nil
      end              
    end
  end
  
  describe "the summary" do
    it "should be singluar if there is one word" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.stub!(:words).and_return(["one"])
      <%=rule_name%>.summary.should == "Match the word one"
    end

    it "should be plural if there are multiple words" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.stub!(:words).and_return(["one", "two", "three"])
      <%=rule_name%>.summary.should == "Match the words one, two, three"
    end        
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:title).and_return("mock title")
      <%=rule_name%>.should_receive(:words).and_return(["one", "two"])
      <%=rule_name%>.should_receive(:workflow_action).and_return("workflow action")
      <%=rule_name%>.should_receive(:workflow).and_return("workflow")
      <%=rule_name%>.data.should == '["mock title",["one","two"],"workflow action","workflow"]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be next" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:workflow_action).and_return('next')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::NEXT]
    end
    
    it "should be stop success" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:workflow_action).and_return('stop_success')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::STOP_SUCCESS]
    end
    
    it "should be stop failure" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:workflow_action).and_return('stop_failure')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::STOP_FAILURE]
    end
    
    it "should be start workflow" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:workflow_action).and_return('start_workflow')
      <%=rule_name%>.should_receive(:workflow).and_return('mock workflow')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::START_WORKFLOW, :workflow_code => "mock workflow"]
    end
    
    it "should be next be default" do
      <%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      <%=rule_name%>.should_receive(:workflow_action).and_return('this is not valid')
      <%=rule_name%>.expected_outcomes.should == [:outcome => RulesEngine::Rule::Outcome::NEXT]
    end
    
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
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

    describe "setting the <%=rule_name%>_words" do
      it "should set the words" do
        @<%=rule_name%>.attributes = valid_attributes
        @<%=rule_name%>.words.should == ['first word', 'second word']
      end            
    
      it "should not be valid if the '<%=rule_name%>_words' attribute is missing" do
        @<%=rule_name%>.attributes = valid_attributes.except(:<%=rule_name%>_words)
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_words)      
      end            
    
      it "should not be valid if the '<%=rule_name%>_words' is not a hash" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_words => "<%=rule_name%> word")
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_words)
      end                

      it "should not be valid if the '<%=rule_name%>_words' is empty" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_words => {})
        @<%=rule_name%>.should_not be_valid
        @<%=rule_name%>.errors.should include(:<%=rule_name%>_words)
      end                
      
      it "should not include parameters that are marked for deletion" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_words => {
                                                                              "1" => { "word" => 'first word', "_delete" => '1'  },
                                                                              "2" => { "word" => 'second word' }
                                                                            }         
         )
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.words.should == ['second word']
      end
          
    end

    describe "setting the <%=rule_name%>_workflow" do
      it "should set the workflow action" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "mock action")        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow_action.should == 'mock action'
      end

      it "should set the workflow action to 'continue' by default" do
        @<%=rule_name%>.attributes = valid_attributes.except(:<%=rule_name%>_workflow_action)        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow_action.should == 'continue'
      end

      it "should set the workflow" do
        @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow => "mock workflow")        
        @<%=rule_name%>.should be_valid
        @<%=rule_name%>.workflow.should == 'mock workflow'
      end
          
      describe "workflow action is start_workflow" do
        it "should be valid with valid '<%=rule_name%>_workflow'" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow", :<%=rule_name%>_workflow => "mock workflow")        
          @<%=rule_name%>.should be_valid
          @<%=rule_name%>.workflow.should == 'mock workflow'
        end            
        
        it "should not be valid if the '<%=rule_name%>_workflow' attribute is missing" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow").except(:<%=rule_name%>_workflow)        
          @<%=rule_name%>.should_not be_valid
          @<%=rule_name%>.errors.should include(:<%=rule_name%>_workflow)
        end            

        it "should not be valid if the '<%=rule_name%>_workflow' attribute is blank" do
          @<%=rule_name%>.attributes = valid_attributes.merge(:<%=rule_name%>_workflow_action => "start_workflow", :<%=rule_name%>_workflow => "")        
          @<%=rule_name%>.should_not be_valid
          @<%=rule_name%>.errors.should include(:<%=rule_name%>_workflow)
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
      @<%=rule_name%> = RulesEngine::Rule::<%=rule_class%>.new
      @<%=rule_name%>.stub!(:words).and_return(["found", "word"])
    end
    
    it "should do nothing if there is no tweet" do      
      @<%=rule_name%>.process(1001, {}).outcome.should == RulesEngine::Rule::Outcome::NEXT
    end        
  
    it "should do nothing if there is no match" do
      @<%=rule_name%>.process(@job, {:tweet => "not here"}).outcome.should == RulesEngine::Rule::Outcome::NEXT
    end        
    
    describe "a match found" do
      before(:each) do
        @matched_data = {:tweet => "here is a word"}
      end
      
      it "should add the match to the data" do              
        @<%=rule_name%>.process(@job, @matched_data)
        @matched_data[:match].should == "word"
      end        
      
      it "should audit the match" do  
        RulesEngine::Process.auditor.should_receive(:audit) do |process_id, message, code|
          process_id.should == 1001
          message.should =~ /word$/
        end
        @<%=rule_name%>.process(1001, @matched_data)
      end        
      
      describe "matching workflow actions" do
        it "should return next" do
          @<%=rule_name%>.should_receive(:workflow_action).and_return('next')
          @<%=rule_name%>.process(1001, @matched_data).outcome.should == RulesEngine::Rule::Outcome::NEXT
        end

        it "should return stop_success" do
          @<%=rule_name%>.should_receive(:workflow_action).and_return('stop_success')
          @<%=rule_name%>.process(1001, @matched_data).outcome.should == RulesEngine::Rule::Outcome::STOP_SUCCESS
        end

        it "should return stop_failure" do
          @<%=rule_name%>.should_receive(:workflow_action).and_return('stop_failure')
          @<%=rule_name%>.process(1001, @matched_data).outcome.should == RulesEngine::Rule::Outcome::STOP_FAILURE
        end
        
        it "should return start workflow with the workflow_code" do
          @<%=rule_name%>.should_receive(:workflow_action).and_return('start_workflow')
          @<%=rule_name%>.should_receive(:workflow).and_return('mock_workflow')
          <%=rule_name%>_outcome = @<%=rule_name%>.process(1001, @matched_data)
          <%=rule_name%>_outcome.outcome.should == RulesEngine::Rule::Outcome::START_WORKFLOW
          <%=rule_name%>_outcome.workflow_code.should == "mock_workflow"
        end        
      end
    end    
  end
end

describe ReWorkflowRulesController, :type => :controller  do
  integrate_views
  
  before(:each) do
    controller.instance_eval { flash.stub!(:sweep) }
    
    RulesEngine::Discovery.discover!
    
    controller.stub!(:rules_engine_reader_access_required).and_return(true)
    controller.stub!(:rules_engine_editor_access_required).and_return(true)

    @re_workflow = ReWorkflow.make
    ReWorkflow.stub!(:find).and_return(@re_workflow)
  end  
  
  describe "<%=rule_name%> rule help" do
    it "should assign the <%=rule_name%> rule class" do
      get :help, :rule_class_name => "RulesEngine::Rule::<%=rule_class%>"
      assigns[:rule_class].should == RulesEngine::Rule::<%=rule_class%>
    end
  end
  
  describe "new" do
    it "show the new form" do
      get :new, :rule_class_name => "RulesEngine::Rule::<%=rule_class%>"
      response.should have_tag("form#re_rule_new_form") do
        with_tag("input#<%=rule_name%>_title")     
        with_tag("input#<%=rule_name%>_words_0_word")
        with_tag("select#<%=rule_name%>_workflow_action")
        with_tag("input#<%=rule_name%>_workflow")
      end  
    end
  end

  describe "edit" do
    it "show the edit form" do
      re_rule = ReRule.make(:re_workflow_id => @re_workflow.id, 
                            :rule_class_name => "RulesEngine::Rule::<%=rule_class%>",
                            :data => valid_<%=rule_name%>_rule_data)
      ReRule.stub!(:find).and_return(re_rule)
      
      get :edit, :re_workflow_id => @re_workflow.id, :re_rule_id => 1001, :rule_class_name => "RulesEngine::Rule::<%=rule_class%>"
      response.should have_tag("form#re_rule_edit_form") do
        with_tag("input#<%=rule_name%>_title", :value => 'Rule Title')     
        with_tag("input#<%=rule_name%>_words_0_word", :value => 'word one')
        with_tag("input#<%=rule_name%>_words_1_word", :value => 'word two')
        with_tag("select#<%=rule_name%>_workflow_action", :value => 'start_workflow')
        with_tag("input#<%=rule_name%>_workflow", :value => 'Other Workflow')
      end  
    end
  end
  
end
