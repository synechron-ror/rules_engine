require File.dirname(__FILE__) + '/../../spec_helper'

describe RuleTweetFilter do

  def valid_attributes
    {
      :tweet_filter_title => 'Valid Title',
      :tweet_filter_words => {
                    "1" => { "word" => 'first word'  },
                    "2" => { "word" => 'second word' }
                  }
    }
  end
  
  def valid_json_data
    '["Rule Title", ["one", "two"]]'
  end
  
  it "should be discoverable" do
    RulesEngine::Discovery.rule_class("RuleTweetFilter").should == RuleTweetFilter
  end

  describe "the expected class options" do    
    it "should be in the 'Twitter' group" do
      RuleTweetFilter.options[:group].should == "Twitter"
    end
    
    it "should have the diplay name of 'Twitter Filter'" do
      RuleTweetFilter.options[:display_name].should == "Twitter Filter"
    end

    it "should have the help template of '/re_rule_definitions/rule_tweet_filter/help'" do
      RuleTweetFilter.options[:help_partial].should == '/re_rule_definitions/rule_tweet_filter/help'
    end

    it "should have the new template of '/re_rule_definitions/rule_tweet_filter/new'" do
      RuleTweetFilter.options[:new_partial].should == '/re_rule_definitions/rule_tweet_filter/new'
    end

    it "should have the edit view partial template of '/re_rule_definitions/rule_tweet_filter/edit'" do
      RuleTweetFilter.options[:edit_partial].should == '/re_rule_definitions/rule_tweet_filter/edit'
    end
  end
  
  describe "setting the rule data" do
    before(:each) do
      @filter = RuleTweetFilter.new
      @filter.data = valid_json_data
    end  
    
    describe "the json data is valid" do
      it "should be valid" do
        @filter.should be_valid
      end
            
      it "should set the title" do
        @filter.title.should == "Rule Title"        
      end

      it "should set the words" do
        @filter.words.should == ["one", "two"]
      end
    end

    describe "the data is nil" do
      it "should set the title to nil" do
        @filter.title.should_not be_nil
        @filter.data = nil
        @filter.title.should be_nil
      end
      
      it "should set the words to nil" do
        @filter.words.should_not be_nil
        @filter.data = nil
        @filter.words.should be_nil
      end
    end
  end
  
  describe "the summary" do
    it "should be singluar if there is one word" do
      filter = RuleTweetFilter.new
      filter.stub!(:words).and_return(["one"])
      filter.summary.should == "Filter out tweets with the word one"
    end

    it "should be plural if there are multiple words" do
      filter = RuleTweetFilter.new
      filter.stub!(:words).and_return(["one", "two", "three"])
      filter.summary.should == "Filter out tweets with the words one, two, three"
    end        
  end

  describe "the data" do
    it "should be converted to a json string" do
      filter = RuleTweetFilter.new
      filter.should_receive(:title).and_return(["mock title"])
      filter.should_receive(:words).and_return(["one", "two"])
      filter.data.should == '[["mock title"],["one","two"]]'
    end
  end
  
  describe "the expected_outcomes" do
    it "should be next and stop success" do
      filter = RuleTweetFilter.new
      filter.expected_outcomes.should == [{:outcome => RulesEngine::RuleOutcome::OUTCOME_NEXT}, {:outcome => RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS}]
    end
  end
  
  describe "setting the rule attributes" do
    before(:each) do
      @filter = RuleTweetFilter.new
    end  
    
    it "should be valid with valid attributes" do
      @filter.attributes = valid_attributes
      @filter.should be_valid
    end            

    describe "setting the tweet_filter_title" do
      it "should set the title" do
        @filter.attributes = valid_attributes
        @filter.title.should == 'Valid Title'
      end            
    
      it "should not be valid if the 'tweet_filter_title' attribute is missing" do
        @filter.attributes = valid_attributes.except(:tweet_filter_title)
        @filter.should_not be_valid
        @filter.errors.should include(:tweet_filter_title)      
      end            
    
      it "should not be valid if the 'tweet_filter_title' attribute is blank" do
        @filter.attributes = valid_attributes.merge(:tweet_filter_title => "")
        @filter.should_not be_valid
        @filter.errors.should include(:tweet_filter_title)
      end                
    end

    describe "setting the tweet_filter_words" do
      it "should set the words" do
        @filter.attributes = valid_attributes
        @filter.words.should == ['first word', 'second word']
      end            
    
      it "should not be valid if the 'tweet_filter_words' attribute is missing" do
        @filter.attributes = valid_attributes.except(:tweet_filter_words)
        @filter.should_not be_valid
        @filter.errors.should include(:tweet_filter_words)      
      end            
    
      it "should not be valid if the 'tweet_filter_words' is not a hash" do
        @filter.attributes = valid_attributes.merge(:tweet_filter_words => "filter word")
        @filter.should_not be_valid
        @filter.errors.should include(:tweet_filter_words)
      end                

      it "should not be valid if the 'tweet_filter_words' is empty" do
        @filter.attributes = valid_attributes.merge(:tweet_filter_words => {})
        @filter.should_not be_valid
        @filter.errors.should include(:tweet_filter_words)
      end                
      
      it "should not include parameters that are marked for deletion" do
        @filter.attributes = valid_attributes.merge(:tweet_filter_words => {
                                                                              "1" => { "word" => 'first word', "_delete" => '1'  },
                                                                              "2" => { "word" => 'second word' }
                                                                            }         
         )
        @filter.should be_valid
        @filter.words.should == ['second word']
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
      @filter = RuleTweetFilter.new
      @filter.stub!(:words).and_return(["found", "word"])
    end
    
    it "should do nothing if there is no tweet" do      
      @filter.process(1001, {}).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    end        
  
    it "should do nothing if there is no match" do
      @filter.process(@job, {:tweet => "not here"}).outcome.should == RulesEngine::RuleOutcome::OUTCOME_NEXT
    end        
    
    describe "a match found" do
      before(:each) do
        @matched_data = {:tweet => "here is a word"}
      end
      
      it "should add the match to the data" do              
        @filter.process(@job, @matched_data)
        @matched_data[:match].should == "word"
      end        
      
      it "should audit the match" do  
        RulesEngine::Process.auditor.should_receive(:audit) do |process_id, message, code|
          process_id.should == 1001
          message.should =~ /word$/
        end
        @filter.process(1001, @matched_data)
      end        
      
      it "should return stop_success" do
        @filter.process(1001, @matched_data).outcome.should == RulesEngine::RuleOutcome::OUTCOME_STOP_SUCCESS
      end
    end    
  end
end
