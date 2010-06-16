require File.dirname(__FILE__) + '/../../spec_helper'

describe <%=rule_class%>Rule do

  def valid_attributes
    {
      :<%=rule_name%>_title => 'Valid Title',
      :<%=rule_name%>_words => {
                    "1" => { "word" => 'first word'  },
                    "2" => { "word" => 'second word' }
                  }
    }
  end
  
  def valid_json_data
    '["Rule Title", ["one", "two"], "start_pipeline", "Other Pipeline"]'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("<%=rule_class%>Rule").should == <%=rule_class%>Rule
  end

  describe "the expected class options" do    
    it "should be in the 'Sample Rules' group" do
      <%=rule_class%>Rule.options[:group].should == "Sample Rules"
    end
    
    it "should have the diplay name of 'Find Matching Words'" do
      <%=rule_class%>Rule.options[:display_name].should == "Find Matching Words"
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
    
    describe "the json data is valid" do
      it "should be valid" do
        @<%=rule_name%>_rule.should be_valid
      end
            
      it "should set the title" do
        @<%=rule_name%>_rule.title.should == "Rule Title"        
      end

      it "should set the words" do
        @<%=rule_name%>_rule.words.should == ["one", "two"]
      end

      it "should set the pipeline_action" do
        @<%=rule_name%>_rule.pipeline_action.should == "start_pipeline"
      end

      it "should set the pipeline" do
        @<%=rule_name%>_rule.pipeline.should == "Other Pipeline"
      end        
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @<%=rule_name%>_rule.title.should_not be_nil
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.title.should be_nil
      end
      
      it "should set the words to nil" do
        @<%=rule_name%>_rule.words.should_not be_nil
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.words.should be_nil
      end

      it "should se the pipeline action to 'continue'" do
        @<%=rule_name%>_rule.pipeline_action.should_not == 'continue'
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.pipeline_action.should == 'continue'
      end
      
      it "should set the 'pipeline' to nil" do
        @<%=rule_name%>_rule.pipeline.should_not be_nil
        @<%=rule_name%>_rule.data = nil
        @<%=rule_name%>_rule.pipeline.should be_nil
      end              
    end
  end
  
  describe "the summary" do
    it "should be singluar if there is one word" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:words).and_return(["one"])
      <%=rule_name%>_rule.summary.should == "Look for 1 matching word"
    end

    it "should be plural if there are multiple words" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:words).and_return(["one", "two", "three"])
      <%=rule_name%>_rule.summary.should == "Look for 3 matching words"
    end        
  end

  describe "the data" do
    it "should be converted to a json string" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:title).and_return(["mock title"])
      <%=rule_name%>_rule.should_receive(:words).and_return(["one", "two"])
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return(["pipeline action"])
      <%=rule_name%>_rule.should_receive(:pipeline).and_return(["pipeline"])
      <%=rule_name%>_rule.data.should == '[["mock title"],["one","two"],["pipeline action"],["pipeline"]]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be next" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return('next')
      <%=rule_name%>_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    end
    
    it "should be stop success" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return('stop_success')
      <%=rule_name%>_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS]
    end
    
    it "should be stop failure" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return('stop_failure')
      <%=rule_name%>_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE]
    end
    
    it "should be start pipeline" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return('start_pipeline')
      <%=rule_name%>_rule.should_receive(:pipeline).and_return('mock pipeline')
      <%=rule_name%>_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "mock pipeline"]
    end
    
    it "should be next be default" do
      <%=rule_name%>_rule = <%=rule_class%>Rule.new
      <%=rule_name%>_rule.should_receive(:pipeline_action).and_return('this is not valid')
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

    describe "setting the <%=rule_name%>_words" do
      it "should set the words" do
        @<%=rule_name%>_rule.attributes = valid_attributes
        @<%=rule_name%>_rule.words.should == ['first word', 'second word']
      end            
    
      it "should not be valid if the '<%=rule_name%>_words' attribute is missing" do
        @<%=rule_name%>_rule.attributes = valid_attributes.except(:<%=rule_name%>_words)
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_words)      
      end            
    
      it "should not be valid if the '<%=rule_name%>_words' is not a hash" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_words => "<%=rule_name%> word")
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_words)
      end                

      it "should not be valid if the '<%=rule_name%>_words' is empty" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_words => {})
        @<%=rule_name%>_rule.should_not be_valid
        @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_words)
      end                
      
      it "should not include parameters that are marked for deletion" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_words => {
                                                                              "1" => { "word" => 'first word', "_delete" => '1'  },
                                                                              "2" => { "word" => 'second word' }
                                                                            }         
         )
        @<%=rule_name%>_rule.should be_valid
        @<%=rule_name%>_rule.words.should == ['second word']
      end
          
    end

    describe "setting the <%=rule_name%>_pipeline" do
      it "should set the pipeline action" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_pipeline_action => "mock action")        
        @<%=rule_name%>_rule.should be_valid
        @<%=rule_name%>_rule.pipeline_action.should == 'mock action'
      end

      it "should set the pipeline action to 'continue' by default" do
        @<%=rule_name%>_rule.attributes = valid_attributes.except(:<%=rule_name%>_pipeline_action)        
        @<%=rule_name%>_rule.should be_valid
        @<%=rule_name%>_rule.pipeline_action.should == 'continue'
      end

      it "should set the pipeline" do
        @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_pipeline => "mock pipeline")        
        @<%=rule_name%>_rule.should be_valid
        @<%=rule_name%>_rule.pipeline.should == 'mock pipeline'
      end
          
      describe "pipeline action is start_pipeline" do
        it "should be valid with valid '<%=rule_name%>_pipeline'" do
          @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_pipeline_action => "start_pipeline", :<%=rule_name%>_pipeline => "mock pipeline")        
          @<%=rule_name%>_rule.should be_valid
          @<%=rule_name%>_rule.pipeline.should == 'mock pipeline'
        end            
        
        it "should not be valid if the '<%=rule_name%>_pipeline' attribute is missing" do
          @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_pipeline_action => "start_pipeline").except(:<%=rule_name%>_pipeline)        
          @<%=rule_name%>_rule.should_not be_valid
          @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_pipeline)
        end            

        it "should not be valid if the '<%=rule_name%>_pipeline' attribute is blank" do
          @<%=rule_name%>_rule.attributes = valid_attributes.merge(:<%=rule_name%>_pipeline_action => "start_pipeline", :<%=rule_name%>_pipeline => "")        
          @<%=rule_name%>_rule.should_not be_valid
          @<%=rule_name%>_rule.errors.should include(:<%=rule_name%>_pipeline)
        end            
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
      @<%=rule_name%>_rule.stub!(:words).and_return(["mock", "words"])      
      @data = {:sentence => "there was a mock sentence"}
    end
    
    it "should do nothing if there is no sentance" do
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new
      @<%=rule_name%>_rule.process(101, {}).should be_nil
    end        

    it "should do nothing if there is no match" do
      @<%=rule_name%>_rule = <%=rule_class%>Rule.new
      @<%=rule_name%>_rule.stub!(:words).and_return(["no", "words"])      
      @<%=rule_name%>_rule.process(101, @data).should be_nil
    end        
    
    describe "a match found" do
      it "should add the match to the data" do      
        @<%=rule_name%>_rule.process(101, @data)
        @data[:match].should == "mock"
      end        
    
      it "should return next" do
        @<%=rule_name%>_rule.should_receive(:pipeline_action).and_return('next')
        @<%=rule_name%>_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
      end

      it "should return stop success" do
        @<%=rule_name%>_rule.should_receive(:pipeline_action).and_return('stop_success')
        @<%=rule_name%>_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
      end

      it "should return stop failure" do
        @<%=rule_name%>_rule.should_receive(:pipeline_action).and_return('stop_failure')
        @<%=rule_name%>_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
      end

      it "should return start pipeline with the pipeline_code" do
        @<%=rule_name%>_rule.should_receive(:pipeline_action).and_return('start_pipeline')
        @<%=rule_name%>_rule.should_receive(:pipeline).and_return('mock_pipeline')
        <%=rule_name%>_rule_outcome = @<%=rule_name%>_rule.process(101, @data)
        <%=rule_name%>_rule_outcome.outcome.should == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
        <%=rule_name%>_rule_outcome.pipeline_code.should == "mock_pipeline"
      end

      it "should return nextv for an unknown action" do
        @<%=rule_name%>_rule.should_receive(:pipeline_action).and_return('this is not a valid action')
        @<%=rule_name%>_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
      end
    end    
  end
end
