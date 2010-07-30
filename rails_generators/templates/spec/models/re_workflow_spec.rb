require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReWorkflow do
  def valid_attributes
    {
      :code => "AA MOCK",
      :title => "Rule Title"
    }
  end

  it "should be valid with valid attributes" do
    ReWorkflow.new(valid_attributes).should be_valid
  end

  should_have_many :re_plan_workflows
  should_have_many :re_plans, :through => :re_plan_workflows
  should_have_many :re_rules
          
  should_validate_presence_of :code
  should_validate_presence_of :title
  
  describe "unique attributes" do
    before(:each) do
      ReWorkflow.create!(valid_attributes)
    end
  
    should_validate_uniqueness_of :code, :case_sensitive => false, :message=>"alread taken."    
  end  
  
  describe "changing a workflow" do
    it "should mark the workflow as changed" do
      re_workflow = ReWorkflow.create!(valid_attributes)
      re_workflow.title = "new title"
      re_workflow.should_receive(:changed!)
      re_workflow.save      
    end        
    
    it "should not be changed if the field changed was an ignore attribute" do
      re_workflow = ReWorkflow.create!(valid_attributes)
      re_workflow.updated_at = Time.now + 5.days
      re_workflow.should_not_receive(:changed!)
      re_workflow.save      
    end        
  end  
  
  describe "destroying a workflow" do
    it "should set the plan as changed" do
      re_workflow = ReWorkflow.create!(valid_attributes)
      re_workflow.stub!(:re_plans).and_return([re_plan = mock_model(RePlan)])
      re_plan.should_receive(:changed!)
      re_workflow.destroy
    end        
  end    
  
  it "should replace any nonprint cahracters with an _" do
    re_workflow = ReWorkflow.new(valid_attributes.merge(:code => "my code"))
    re_workflow.save!
    re_workflow.code.should == "my_code"
  end
    
  it "should change the code to lower case when creating" do
    re_workflow = ReWorkflow.new(valid_attributes.merge(:code => "My code"))
    re_workflow.save!
    re_workflow.code.should == "my_code"
  end

  it "should strip any leading or trailing spaces" do
    re_workflow = ReWorkflow.new(valid_attributes.merge(:code => "  My code  "))
    re_workflow.save!
    re_workflow.code.should == "my_code"
  end
    
  describe "code cannot be changed after creation" do
    it "should save the code with a new record" do
      re_workflow = ReWorkflow.new(valid_attributes.merge(:code => "my code"))
      re_workflow.save!
      re_workflow.code.should == "my_code"
    end
    
    it "should ignore the code attribute for an existing record" do
      re_workflow = ReWorkflow.new(valid_attributes.merge(:code => "my code"))
      re_workflow.save!
      re_workflow.code = "new_code"
      re_workflow.save!
      re_workflow.code.should == "my_code"
    end            
  end

  describe "publish" do
    it "should convert the workflow to a hash" do
      re_workflow = ReWorkflow.new(valid_attributes)
      re_workflow.stub!(:re_rules).and_return([mock('rule one', :publish => "rule one"), mock('rule two', :publish => "rule two")])
      
      publish_data = re_workflow.publish
      publish_data["code"].should == 'aa_mock'
      publish_data["title"].should == valid_attributes[:title]
      publish_data["description"].should == valid_attributes[:description]
      publish_data["rules"].should == ['rule one', 'rule two']
    end
  end

  describe "revert!" do
    it "should return self" do
      re_workflow = ReWorkflow.new
      re_workflow.revert!({}).should == re_workflow
    end

    it "should set the workflow based on the data" do
      re_rule_1 = mock_model(ReRule)
      re_rule_2 = mock_model(ReRule)
      re_rule_1.should_receive(:revert!).with('rule one').and_return(re_rule_1)
      re_rule_2.should_receive(:revert!).with('rule two').and_return(re_rule_2)
      ReRule.stub!(:new).and_return(re_rule_1, re_rule_2)
      
      re_workflow = ReWorkflow.new
      re_workflow.should_receive(:re_rules=).with([re_rule_1, re_rule_2])
      
      re_workflow.revert!({"code" => "mock_rule_code", 
                            "title" => "mock_title", 
                            "description" => "mock_description",
                            "rules" => ["rule one", "rule two"]})
                            
     re_workflow.code.should == "mock_rule_code"
     re_workflow.title.should == "mock_title"
     re_workflow.description.should == "mock_description"
    end
  end
  
  describe "checking for workflow errors" do
    before(:each) do
      @re_rule1 = mock_model(ReRule, :title => "rule 1", :rule_class_name => "rule_class_1")
      @re_rule1.stub!(:rule_error).and_return(nil)
      
      @re_rule2 = mock_model(ReRule, :title => "rule 2", :rule_class_name => "rule_class_2")
      @re_rule2.stub!(:rule_error).and_return(nil)
  
      @re_workflow = ReWorkflow.new
      @re_workflow.stub!(:re_rules).and_return([@re_rule1, @re_rule2])
    end
    
    it "should return a failed message if there are no rules" do
      src = ReWorkflow.new(valid_attributes)
      src.workflow_error.should == "rules required"
    end
    
    it "should validate each rule" do
      @re_rule1.should_receive(:rule_error).at_least(:once).and_return(nil)
      @re_rule2.should_receive(:rule_error).at_least(:once).and_return(nil)
      
      @re_workflow.workflow_error.should be_nil
    end
  
    it "should stop on the first rule error" do
      @re_rule1.should_receive(:rule_error).at_least(:once).and_return("oops")
      @re_rule2.should_not_receive(:rule)
      
      @re_workflow.workflow_error.should == "error within rules"
    end
  end

  describe "changed!" do
    it "should update all of the plans that the rule has changed" do
      re_plan_1 = mock('RePlan')
      re_plan_2 = mock('RePlan')
      re_workflow = ReWorkflow.new(valid_attributes)
      re_workflow.stub(:re_plans).and_return([re_plan_1, re_plan_2])

      re_plan_1.should_receive(:changed!)
      re_plan_2.should_receive(:changed!)
      
      re_workflow.changed!
    end
  end
  
  describe "has_plan?" do
    it "should return true when the plan one of the plans" do
      re_plan_1 = mock('RePlan')
      re_plan_2 = mock('RePlan')
      re_workflow = ReWorkflow.new(valid_attributes)
      re_workflow.stub(:re_plans).and_return([re_plan_1, re_plan_2])
      
      re_workflow.has_plan?(re_plan_1).should == true
    end
    
    it "should return false when the plan is not in the plans" do
      re_plan_1 = mock('RePlan')
      re_plan_2 = mock('RePlan')
      re_workflow = ReWorkflow.new(valid_attributes)
      re_workflow.stub(:re_plans).and_return([re_plan_1, re_plan_2])
      
      re_workflow.has_plan?(mock('RePlan')).should == false
    end            
  end
  
end
