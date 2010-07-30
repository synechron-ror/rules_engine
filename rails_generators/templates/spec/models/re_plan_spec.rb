require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePlan do
  def valid_attributes
    {
      :code => "AA MOCK",
      :title => "Rule Title"
    }
  end

  it "should be valid with valid attributes" do
    RePlan.new(valid_attributes).should be_valid
  end

  should_have_many :re_plan_workflows
  should_have_many :re_workflows, :through => :re_plan_workflows
          
  should_validate_presence_of :code
  should_validate_presence_of :title
  
  describe "unique attributes" do
    before(:each) do
      RePlan.create!(valid_attributes)
    end
  
    should_validate_uniqueness_of :code, :case_sensitive => false, :message=>"alread taken."    
  end  

  describe "creating a plan" do
    it "should set the plan_status to draft" do
      re_plan = RePlan.create!(valid_attributes.except(:plan_status))
      re_plan.plan_status.should == RePlan::PLAN_STATUS_DRAFT
    end        
  end  
  
  describe "changing a plan" do
    describe "changing a plan back to it's reverted state" do
      it "should mark the plan as published when saving" do
        re_plan = RePlan.create!(valid_attributes)
        re_plan.plan_status = RePlan::PLAN_STATUS_REVERTED
        re_plan.save      
        re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
      end        

      it "should not mark the plan as changed" do
        re_plan = RePlan.create!(valid_attributes)
        re_plan.plan_status = RePlan::PLAN_STATUS_REVERTED
        re_plan.title = "new title"
        re_plan.should_not_receive(:changed!)
        re_plan.save      
      end        
    end

    it "should mark the plan as changed" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.title = "new title"
      re_plan.should_receive(:changed!).with(false)
      re_plan.save      
    end        
    
    it "should not be changed if the field changed was an ignore attribute" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.updated_at = Time.now + 5.days
      re_plan.should_not_receive(:changed!)
      re_plan.save      
    end        
  end  
  
  it "should replace any nonprint cahracters with an _" do
    re_plan = RePlan.new(valid_attributes.merge(:code => "my code"))
    re_plan.save!
    re_plan.code.should == "my_code"
  end
    
  it "should change the code to lower case when creating" do
    re_plan = RePlan.new(valid_attributes.merge(:code => "My code"))
    re_plan.save!
    re_plan.code.should == "my_code"
  end

  it "should strip any leading or trailing spaces" do
    re_plan = RePlan.new(valid_attributes.merge(:code => "  My code  "))
    re_plan.save!
    re_plan.code.should == "my_code"
  end
    
  describe "code cannot be changed after creation" do
    it "should save the code with a new record" do
      re_plan = RePlan.new(valid_attributes.merge(:code => "my code"))
      re_plan.save!
      re_plan.code.should == "my_code"
    end
    
    it "should ignore the code attribute for an existing record" do
      re_plan = RePlan.new(valid_attributes.merge(:code => "my code"))
      re_plan.save!
      re_plan.code = "new_code"
      re_plan.save!
      re_plan.code.should == "my_code"
    end            
  end
  
  describe "publish" do
    it "should convert the plan to a hash" do
      re_plan = RePlan.new(valid_attributes)
      re_plan.stub!(:re_workflows).and_return([mock('workflow one', :code => 'one', :publish => {"workflow" => "one"}), 
                                               mock('workflow two', :code => 'two', :publish => {"workflow" => "two"})])      
      publish_data = re_plan.publish
      publish_data["code"].should == 'aa_mock'
      publish_data["title"].should == valid_attributes[:title]
      publish_data["description"].should == valid_attributes[:description]
      publish_data["run_workflow"].should == "one"
      publish_data["workflow_one"]["workflow"].should == "one"
      publish_data["workflow_one"]["next_workflow"].should == "two"
      publish_data["workflow_two"]["workflow"].should == "two"
      publish_data["workflow_two"]["next_workflow"].should == ""
    end
  end

  describe "revert!" do
    it "should return self" do
      re_plan = RePlan.new
      re_plan.revert!({}).should == re_plan
    end
    
    it "should set the plan as reverted" do
      re_plan = RePlan.new
      re_plan.revert!({})
      re_plan.plan_status.should == RePlan::PLAN_STATUS_REVERTED
    end
        
    it "should set the plan based on the data" do
      re_workflow_1 = mock_model(ReWorkflow)
      re_workflow_2 = mock_model(ReWorkflow)
      re_workflow_1.should_receive(:revert!).with(hash_including('workflow' => 'one')).and_return(re_workflow_1)
      re_workflow_2.should_receive(:revert!).with(hash_including('workflow' => 'two')).and_return(re_workflow_2)
      ReWorkflow.stub!(:new).and_return(re_workflow_1, re_workflow_2)
      
      re_plan = RePlan.new
      re_plan.should_receive(:re_workflows=).with([re_workflow_1, re_workflow_2])
      
      re_plan.revert!({"code" => "mock_workflow_code", 
                            "title" => "mock_title", 
                            "description" => "mock_description",
                            "run_workflow" => "one",
                            "workflow_one" => {"workflow" => "one", "next_workflow" => "two"},
                            "workflow_two" => {"workflow" => "two", "next_workflow" => ""}
                        })
                            
     re_plan.code.should == "mock_workflow_code"
     re_plan.title.should == "mock_title"
     re_plan.description.should == "mock_description"
    end
  end
  
  describe "adding a workflow" do
    it "should be false if it already has the workflow" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_plan.stub!(:re_workflows).and_return([re_workflow])
      re_plan.add_workflow(re_workflow).should == false
    end
    
    it "should add the workflow" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_workflows = []
      re_plan.stub!(:re_workflows).and_return(re_workflows)
      re_plan.add_workflow(re_workflow)
      re_workflows.should == [re_workflow]
    end
    
    it "should mark the plan as changed" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_plan.should_receive(:changed!)
      re_plan.add_workflow(re_workflow)
    end
  end

  describe "removing a workflow" do
    it "should be false if it does not have the workflow" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_plan.stub!(:re_workflows).and_return([])
      re_plan.remove_workflow(re_workflow).should == false
    end
    
    it "should remove the workflow" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_workflows = [re_workflow]
      re_plan.stub!(:re_workflows).and_return(re_workflows)
      re_plan.remove_workflow(re_workflow)
      re_workflows.should == []
    end
    
    it "should mark the plan as changed" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow)
      re_plan.stub!(:re_workflows).and_return([re_workflow])
      re_plan.should_receive(:changed!)
      re_plan.remove_workflow(re_workflow)
    end
  end
  
  describe "setting the default workflow" do
    
    it "should not change the list if the workflow is not in the list" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow, :id => 1001)
      re_plan.stub!(:re_workflows).and_return([])

      re_plan.should_not_receive(:changed!)
      re_plan.default_workflow = re_workflow
    end
    
    it "should not change the list if the workflow is alreasy the default" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow, :id => 1001)
      re_plan.stub!(:re_workflows).and_return([re_workflow])
      
      re_plan.should_not_receive(:changed!)
      re_plan.default_workflow = re_workflow      
    end
    
    it "should move the workflow to the top of the list" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow, :id => 1001)
      re_plan.stub!(:re_workflows).and_return([mock_model(ReWorkflow, :id => 1001), re_workflow])
      
      re_plan_workflow = mock_model(RePlanWorkflow, :re_workflow_id => 1001)
      re_plan.stub!(:re_plan_workflows).and_return([re_plan_workflow])      
      
      re_plan_workflow.should_receive(:move_to_top)
      re_plan.default_workflow = re_workflow
    end
    
    it "should mark the plan as changed" do
      re_plan = RePlan.new
      re_workflow = mock_model(ReWorkflow, :id => 1001)
      re_plan.stub!(:re_workflows).and_return([mock_model(ReWorkflow, :id => 1001), re_workflow])
      
      re_plan_workflow = mock_model(RePlanWorkflow, :re_workflow_id => 1001)
      re_plan_workflow.stub!(:move_to_top)
      re_plan.stub!(:re_plan_workflows).and_return([re_plan_workflow])      
      
      re_plan.should_receive(:changed!)
      re_plan.default_workflow = re_workflow
    end        
  end
  
  describe "getting the default workflow" do
    it "should return nil if the workflow list empty" do
      re_plan = RePlan.new
      re_plan.stub!(:re_workflows).and_return([])
      re_plan.default_workflow.should == nil
    end

    it "should return the first workflow in the list" do
      re_workflow_1 = mock_model(ReWorkflow)
      re_workflow_2 = mock_model(ReWorkflow)
      re_plan = RePlan.new
      re_plan.stub!(:re_workflows).and_return([re_workflow_1, re_workflow_2])
      re_plan.default_workflow.should == re_workflow_1
    end
  end
  
  describe "checking for plan errors" do
    before(:each) do
      @re_workflow_1 = mock_model(ReRule, :title => "workflow 1")
      @re_workflow_1.stub!(:workflow_error).and_return(nil)
      
      @re_workflow_2 = mock_model(ReRule, :title => "workflow 2")
      @re_workflow_2.stub!(:workflow_error).and_return(nil)
  
      @re_plan = RePlan.new
      @re_plan.stub!(:re_workflows).and_return([@re_workflow_1, @re_workflow_2])
    end
    
    it "should return a failed message if there are no workflows" do
      src = RePlan.new(valid_attributes)
      src.plan_error.should == "workflows req'd"
    end
    
    it "should validate each workflow" do
      @re_workflow_1.should_receive(:workflow_error).at_least(:once).and_return(nil)
      @re_workflow_2.should_receive(:workflow_error).at_least(:once).and_return(nil)
      
      @re_plan.plan_error.should be_nil
    end
  
    it "should stop on the first workflow error" do
      @re_workflow_1.should_receive(:workflow_error).at_least(:once).and_return("oops")
      @re_workflow_2.should_not_receive(:workflow)
      
      @re_plan.plan_error.should == "workflow error"
    end
  end

  describe "published!" do
    it "should update the status to PLAN_STATUS_PUBLISHED" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.plan_status.should == RePlan::PLAN_STATUS_DRAFT
      re_plan.published!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
    end
  end

  describe "changed!" do
    it "should not update the status when PLAN_STATUS_DRAFT" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.plan_status.should == RePlan::PLAN_STATUS_DRAFT
      re_plan.should_not_receive(:save!)
      re_plan.changed!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_DRAFT
    end

    it "should not update the status when PLAN_STATUS_CHANGED" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.published!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
      re_plan.update_attributes({:title => "new title"})
      re_plan.plan_status.should == RePlan::PLAN_STATUS_CHANGED
      re_plan.should_not_receive(:save!)
      re_plan.changed!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_CHANGED
    end

    it "should update the status to PLAN_STATUS_CHANGED changed when PLAN_STATUS_PUBLISHED" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.published!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
      re_plan.should_receive(:save!)
      re_plan.changed!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_CHANGED
    end

    it "should not save the plan whe the save flag is false" do
      re_plan = RePlan.create!(valid_attributes)
      re_plan.published!
      re_plan.plan_status.should == RePlan::PLAN_STATUS_PUBLISHED
      re_plan.should_not_receive(:save!)
      re_plan.changed!(false)
      re_plan.plan_status.should == RePlan::PLAN_STATUS_CHANGED
    end
  end
  
end
