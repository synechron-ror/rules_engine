require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePipelineBase do
  def valid_attributes
    {
      :code => "AA MOCK",
      :title => "Mock Title"
    }
  end

  it "should be valid with valid attributes" do
    RePipelineBase.new(valid_attributes).should be_valid
  end
          
  should_validate_presence_of :code
  should_validate_presence_of :title
  
  describe "unique attributes" do
    before(:each) do
      RePipelineBase.create!(valid_attributes)
    end
  
    should_validate_uniqueness_of :code, :scope => :parent_re_pipeline_id, :case_sensitive => false, :message=>"alread taken."    
  end  

  it "should replace any nonprint cahracters with an _" do
    re_pipeline = RePipelineBase.new(valid_attributes.merge(:code => "my code"))
    re_pipeline.save!
    re_pipeline.code.should == "my_code"
  end
    

  it "should change the code to lower case when creating" do
    re_pipeline = RePipelineBase.new(valid_attributes.merge(:code => "My code"))
    re_pipeline.save!
    re_pipeline.code.should == "my_code"
  end
    
  describe "code cannot be changed after creation" do
    it "should save the code with a new record" do
      re_pipeline = RePipelineBase.new(valid_attributes.merge(:code => "my code"))
      re_pipeline.save!
      re_pipeline.code.should == "my_code"
    end
    
    it "should ignore the code attribute for an existing record" do
      re_pipeline = RePipelineBase.new(valid_attributes.merge(:code => "my code"))
      re_pipeline.save!
      re_pipeline.code = "new_code"
      re_pipeline.save!
      re_pipeline.code.should == "my_code"
    end            
  end

  describe "copying the pipeline" do
    
    %W(code title description).each do |key|
      it "should copy the attribute #{key}" do
        src = RePipelineBase.new(valid_attributes.merge(key.to_sym => "mock_source_value"))
        dest = RePipelineBase.new(valid_attributes.merge(key.to_sym => "mock_dest_value"))
        dest.copy!(src)
        dest.read_attribute(key).should == "mock_source_value"
      end
      
      it "should copy the rules" do
        src = RePipelineBase.new(valid_attributes)
        dest = RePipelineBase.new(valid_attributes)
        
        src_rule = mock_model(ReRule)
        dest_rule = mock_model(ReRule)
                
        ReRule.should_receive(:new).and_return(dest_rule)
        dest_rule.should_receive(:copy!).with(src_rule).and_return(dest_rule)
        
        src.should_receive(:re_rules).and_return([src_rule])
        dest.should_receive(:re_rules=).with([dest_rule])
        
        dest.copy!(src)
      end
    end
  end
  
  describe "comparing pipeline" do
    it "should be equal if the attributes are equal" do
      src = RePipelineBase.new(valid_attributes)
      dest =RePipelineBase.new(valid_attributes)
      dest.equals?(src).should be_true
    end
    
    %W(code title description).each do |key|
      it "should not be equal if the attribute #{key} are different" do
        src = RePipelineBase.new(valid_attributes.merge(key.to_sym => "mock source value"))
        dest = RePipelineBase.new(valid_attributes.merge(key.to_sym => "mock dest value"))
        dest.equals?(src).should be_false
      end
    end

    describe "equals rule" do
      before(:each) do
        @rule_1 = mock_model(ReRule)
        @rule_2 = mock_model(ReRule)
        @re_pipeline_1 = RePipeline.new(valid_attributes)
        @re_pipeline_2 = RePipeline.new(valid_attributes)
        @re_pipeline_1.stub!(:re_rules).and_return([@rule_1, @rule_2])
        @re_pipeline_2.stub!(:re_rules).and_return([@rule_1, @rule_2])
      end
      
      it "should not compare the rules if the the number is different" do
        @re_pipeline_2.stub!(:re_rules).and_return([@rule_1])
      
        @rule_1.should_not_receive(:equals?)
        @rule_2.should_not_receive(:equals?)
      
        @re_pipeline_1.equals?(@re_pipeline_2)
      end
    
      it "should check the equals status of each rule outcome" do
        @rule_1.should_receive(:equals?).with(@rule_1).and_return(true)
        @rule_2.should_receive(:equals?).with(@rule_2).and_return(true)
      
        @re_pipeline_1.equals?(@re_pipeline_2).should be_true
      end
      
      it "should stop on the rule outcome equals error" do
        @rule_1.should_receive(:equals?).with(@rule_1).and_return(false)
        @rule_2.should_not_receive(:equals?)
      
        @re_pipeline_1.equals?(@re_pipeline_2).should be_false
      end
    end
  end  
  
  describe "checking for pipeline errors" do
    before(:each) do
      @re_rule1 = mock_model(ReRule, :title => "rule 1", :rule_class_name => "rule_class_1")
      @re_rule1.stub!(:rule_error).and_return(nil)
      
      @re_rule2 = mock_model(ReRule, :title => "rule 2", :rule_class_name => "rule_class_2")
      @re_rule2.stub!(:rule_error).and_return(nil)

      @re_pipeline = RePipelineBase.new
      @re_pipeline.stub!(:re_rules).and_return([@re_rule1, @re_rule2])
    end
    
    it "should return a failed message if there are no rules" do
      src = RePipelineBase.new(valid_attributes)
      src.pipeline_error.should == "rules required"
    end
    
    it "should validate each rule" do
      @re_rule1.should_receive(:rule_error).at_least(:once).and_return(nil)
      @re_rule2.should_receive(:rule_error).at_least(:once).and_return(nil)
      
      @re_pipeline.pipeline_error.should be_nil
    end

    it "should stop on the first rule error" do
      @re_rule1.should_receive(:rule_error).at_least(:once).and_return("oops")
      @re_rule2.should_not_receive(:rule)
      
      @re_pipeline.pipeline_error.should == "error within rules"
    end
  end
end
