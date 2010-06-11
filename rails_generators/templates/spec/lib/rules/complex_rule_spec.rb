require File.dirname(__FILE__) + '/../../spec_helper'

describe ComplexRule do

  def valid_attributes
    {
      :complex_title => 'Valid Title',
      :complex_words => {
                    "1" => { "word" => 'first word'  },
                    "2" => { "word" => 'second word' }
                  }
    }
  end
  
  def valid_json_data
    '["Rule Title", ["one", "two"], "start_pipeline", "Other Pipeline"]'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("ComplexRule").should == ComplexRule
  end

  describe "the expected class options" do    
    it "should be in the 'Sample Rules' group" do
      ComplexRule.options[:group].should == "Sample Rules"
    end
    
    it "should have the diplay name of 'Find Matching Words'" do
      ComplexRule.options[:display_name].should == "Find Matching Words"
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
  
  describe "setting the rule data" do
    before(:each) do
      @complex_rule = ComplexRule.new
      @complex_rule.data = valid_json_data
    end  
    
    describe "the json data is valid" do
      it "should be valid" do
        @complex_rule.should be_valid
      end
            
      it "should set the title" do
        @complex_rule.title.should == "Rule Title"        
      end

      it "should set the words" do
        @complex_rule.words.should == ["one", "two"]
      end

      it "should set the pipeline_action" do
        @complex_rule.pipeline_action.should == "start_pipeline"
      end

      it "should set the pipeline" do
        @complex_rule.pipeline.should == "Other Pipeline"
      end        
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @complex_rule.title.should_not be_nil
        @complex_rule.data = nil
        @complex_rule.title.should be_nil
      end
      
      it "should set the words to nil" do
        @complex_rule.words.should_not be_nil
        @complex_rule.data = nil
        @complex_rule.words.should be_nil
      end

      it "should se the pipeline action to 'continue'" do
        @complex_rule.pipeline_action.should_not == 'continue'
        @complex_rule.data = nil
        @complex_rule.pipeline_action.should == 'continue'
      end
      
      it "should set the 'pipeline' to nil" do
        @complex_rule.pipeline.should_not be_nil
        @complex_rule.data = nil
        @complex_rule.pipeline.should be_nil
      end              
    end
  end
  
  describe "the summary" do
    it "should be singluar if there is one word" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:words).and_return(["one"])
      complex_rule.summary.should == "Look for 1 matching word"
    end

    it "should be plural if there are multiple words" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:words).and_return(["one", "two", "three"])
      complex_rule.summary.should == "Look for 3 matching words"
    end        
  end

  describe "the data" do
    it "should be converted to a json string" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:title).and_return(["mock title"])
      complex_rule.should_receive(:words).and_return(["one", "two"])
      complex_rule.should_receive(:pipeline_action).and_return(["pipeline action"])
      complex_rule.should_receive(:pipeline).and_return(["pipeline"])
      complex_rule.data.should == '[["mock title"],["one","two"],["pipeline action"],["pipeline"]]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be next" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:pipeline_action).and_return('next')
      complex_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    end
    
    it "should be stop success" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:pipeline_action).and_return('stop_success')
      complex_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS]
    end
    
    it "should be stop failure" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:pipeline_action).and_return('stop_failure')
      complex_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE]
    end
    
    it "should be start pipeline" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:pipeline_action).and_return('start_pipeline')
      complex_rule.should_receive(:pipeline).and_return('mock pipeline')
      complex_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE, :pipeline_code => "mock pipeline"]
    end
    
    it "should be next be default" do
      complex_rule = ComplexRule.new
      complex_rule.should_receive(:pipeline_action).and_return('this is not valid')
      complex_rule.expected_outcomes.should == [:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT]
    end
    
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @complex_rule = ComplexRule.new
    end  
    
    it "should be valid with valid attributes" do
      @complex_rule.attributes = valid_attributes
      @complex_rule.should be_valid
    end            

    describe "setting the complex_title" do
      it "should set the title" do
        @complex_rule.attributes = valid_attributes
        @complex_rule.title.should == 'Valid Title'
      end            
    
      it "should not be valid if the 'complex_title' attribute is missing" do
        @complex_rule.attributes = valid_attributes.except(:complex_title)
        @complex_rule.should_not be_valid
        @complex_rule.errors.should include(:complex_title)      
      end            
    
      it "should not be valid if the 'complex_title' attribute is blank" do
        @complex_rule.attributes = valid_attributes.merge(:complex_title => "")
        @complex_rule.should_not be_valid
        @complex_rule.errors.should include(:complex_title)
      end                
    end

    describe "setting the complex_words" do
      it "should set the words" do
        @complex_rule.attributes = valid_attributes
        @complex_rule.words.should == ['first word', 'second word']
      end            
    
      it "should not be valid if the 'complex_words' attribute is missing" do
        @complex_rule.attributes = valid_attributes.except(:complex_words)
        @complex_rule.should_not be_valid
        @complex_rule.errors.should include(:complex_words)      
      end            
    
      it "should not be valid if the 'complex_words' is not a hash" do
        @complex_rule.attributes = valid_attributes.merge(:complex_words => "complex word")
        @complex_rule.should_not be_valid
        @complex_rule.errors.should include(:complex_words)
      end                

      it "should not be valid if the 'complex_words' is empty" do
        @complex_rule.attributes = valid_attributes.merge(:complex_words => {})
        @complex_rule.should_not be_valid
        @complex_rule.errors.should include(:complex_words)
      end                
      
      it "should not include parameters that are marked for deletion" do
        @complex_rule.attributes = valid_attributes.merge(:complex_words => {
                                                                              "1" => { "word" => 'first word', "_delete" => '1'  },
                                                                              "2" => { "word" => 'second word' }
                                                                            }         
         )
        @complex_rule.should be_valid
        @complex_rule.words.should == ['second word']
      end
          
    end

    describe "setting the complex_pipeline" do
      it "should set the pipeline action" do
        @complex_rule.attributes = valid_attributes.merge(:complex_pipeline_action => "mock action")        
        @complex_rule.should be_valid
        @complex_rule.pipeline_action.should == 'mock action'
      end

      it "should set the pipeline action to 'continue' by default" do
        @complex_rule.attributes = valid_attributes.except(:complex_pipeline_action)        
        @complex_rule.should be_valid
        @complex_rule.pipeline_action.should == 'continue'
      end

      it "should set the pipeline" do
        @complex_rule.attributes = valid_attributes.merge(:complex_pipeline => "mock pipeline")        
        @complex_rule.should be_valid
        @complex_rule.pipeline.should == 'mock pipeline'
      end
          
      describe "pipeline action is start_pipeline" do
        it "should be valid with valid 'complex_pipeline'" do
          @complex_rule.attributes = valid_attributes.merge(:complex_pipeline_action => "start_pipeline", :complex_pipeline => "mock pipeline")        
          @complex_rule.should be_valid
          @complex_rule.pipeline.should == 'mock pipeline'
        end            
        
        it "should not be valid if the 'complex_pipeline' attribute is missing" do
          @complex_rule.attributes = valid_attributes.merge(:complex_pipeline_action => "start_pipeline").except(:complex_pipeline)        
          @complex_rule.should_not be_valid
          @complex_rule.errors.should include(:complex_pipeline)
        end            

        it "should not be valid if the 'complex_pipeline' attribute is blank" do
          @complex_rule.attributes = valid_attributes.merge(:complex_pipeline_action => "start_pipeline", :complex_pipeline => "")        
          @complex_rule.should_not be_valid
          @complex_rule.errors.should include(:complex_pipeline)
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
      @complex_rule = ComplexRule.new
      @complex_rule.stub!(:words).and_return(["mock", "words"])      
      @data = {:sentence => "there was a mock sentence"}
    end
    
    it "should do nothing if there is no sentance" do
      @complex_rule = ComplexRule.new
      @complex_rule.process(101, {}).should be_nil
    end        

    it "should do nothing if there is no match" do
      @complex_rule = ComplexRule.new
      @complex_rule.stub!(:words).and_return(["no", "words"])      
      @complex_rule.process(101, @data).should be_nil
    end        
    
    describe "a match found" do
      it "should add the match to the data" do      
        @complex_rule.process(101, @data)
        @data[:match].should == "mock"
      end        
    
      it "should return next" do
        @complex_rule.should_receive(:pipeline_action).and_return('next')
        @complex_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
      end

      it "should return stop success" do
        @complex_rule.should_receive(:pipeline_action).and_return('stop_success')
        @complex_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
      end

      it "should return stop failure" do
        @complex_rule.should_receive(:pipeline_action).and_return('stop_failure')
        @complex_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_STOP_FAILURE
      end

      it "should return start pipeline with the pipeline_code" do
        @complex_rule.should_receive(:pipeline_action).and_return('start_pipeline')
        @complex_rule.should_receive(:pipeline).and_return('mock_pipeline')
        complex_rule_outcome = @complex_rule.process(101, @data)
        complex_rule_outcome.outcome.should == RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE
        complex_rule_outcome.pipeline_code.should == "mock_pipeline"
      end

      it "should return nextv for an unknown action" do
        @complex_rule.should_receive(:pipeline_action).and_return('this is not a valid action')
        @complex_rule.process(101, @data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
      end
    end    
  end
end
