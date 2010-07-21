require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Process::Runner" do

  describe "setting the runner" do
    it "should set the runner as a instance of a class" do
      mock_runner = mock('mock_runner')
      RulesEngine::Process.runner = mock_runner
      RulesEngine::Process.runner.should == mock_runner
    end

    it "should set the runner to the database plan runner" do
      RulesEngine::Process.runner = :db_runner
      RulesEngine::Process.runner.should be_instance_of(RulesEngine::Process::DbRunner)
    end
  end
  
  describe "getting the runner" do
    it "should throw an exception if the runner is not set" do
      RulesEngine::Process.runner = nil
      
      lambda {
        RulesEngine::Process.runner
      }.should raise_error
    end        
  end
  
  describe "creating a process" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Process::Runner.new.create()
      }.should raise_error
    end
  end

  describe "getting the run status" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Process::Runner.new.status(10001)
      }.should raise_error
    end
  end

  describe "getting the run history" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Process::Runner.new.history(10001, {})
      }.should raise_error
    end
  end

  describe "running the plan" do
    before(:each) do
      @rule_class = mock("Rule Class")
      @rule_class.stub!(:new).and_return(@rule_class)
      @rule_class.stub!(:title).and_return('mock title')
      @rule_class.stub!(:data=)
      @rule_class.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT))
      RulesEngine::Discovery.stub!(:rule_class).and_return(@rule_class)

      RulesEngine::Process.auditor.stub!(:audit)# {|one, two, three| puts two }

      @runner = RulesEngine::Process::Runner.new      
      
      @plan = {"code" => "plan_code",
               "first_workflow" => "one",
               
               "workflow_one" => {
                 "rules" => [{
                   "rule_class_name" => "one_one",
                   "data" => "one_one_data",
                 },{
                   "rule_class_name" => "one_two",
                   "data" => "one_two_data",
                 },{
                   "rule_class_name" => "one_three",
                   "data" => "one_two_data",
                 }],
                 "next_workflow" => "two"
               },
               "workflow_two" => {
                 "rules" => [{
                   "rule_class_name" => "two_one",
                   "data" => "two_one_data",
                 }],
                 "next_workflow" => "three"
               },
               "workflow_three" => {
                 "rules" => [{
                   "rule_class_name" => "three_one",
                   "data" => "three_one_data",
                 }],
                 "next_workflow" => ""
               }               
              }
    end
    
    it "should use the _run_plan method" do
      @runner.should_receive(:_run_plan)
      @runner.run(10001, @plan, {})
    end
    
    it "should be successfull with a valid plan" do
      @runner.run(10001, @plan, {}).should == true
    end
        
    it "should audit the plan has started" do
      RulesEngine::Process.auditor.should_receive(:audit).once.with(10001, "Plan : plan_code : started", RulesEngine::Process::AUDIT_INFO)
      @runner.run(10001, @plan, {})
    end

    describe "first_workflow missing" do
      it "should audit the failure" do
        RulesEngine::Process.auditor.should_receive(:audit).once.with(10001, anything, RulesEngine::Process::AUDIT_FAILURE)
        @runner.run(10001, @plan.except("first_workflow"), {})
      end
      
      it "should return false" do
        @runner.run(10001, @plan.except("first_workflow"), {}).should == false
      end
    end    
    
    describe "endless loop" do
      it "should return false" do
        @plan["workflow_one"].merge!("next_workflow" => "one")
        @runner.run(10001, @plan, {}).should == false
      end
    end
    
    describe "workflow missing" do
      it "should return false" do
        @plan["workflow_one"].merge!("next_workflow" => "not_there")
        @runner.run(10001, @plan, {}).should == false
      end
    end
    
    describe "processing the workflows" do
      it "should process each follow the next_workflow " do
        # testing this by checking it runs one rule in each workflow
        RulesEngine::Discovery.should_receive(:rule_class).with("one_one").and_return(@rule_class)
        RulesEngine::Discovery.should_receive(:rule_class).with("two_one").and_return(@rule_class)
        RulesEngine::Discovery.should_receive(:rule_class).with("three_one").and_return(@rule_class)
         @runner.run(10001, @plan, {})
      end          
    end
    
    describe "processing the rules" do
      it "should load the rule" do
        RulesEngine::Discovery.should_receive(:rule_class).with("one_one").and_return(@rule_class)
        @rule_class.should_receive(:new).and_return(@rule_class)
        @rule_class.should_receive(:data=).with("one_one_data")
        @runner.run(10001, @plan, {}).should == true
      end
      
      describe "the rules does not exist" do
        it "should return an error" do
          RulesEngine::Discovery.should_receive(:rule_class).with("one_one").and_return(nil)
          @runner.run(10001, @plan, {}).should == false
        end            
      end
      
      it "should proces the rule" do
        @rule_class.should_receive(:process)
        @runner.run(10001, @plan, {})
      end
      
      describe "processing a rule" do
        before(:each) do
          @test_rule = mock("Test Rule")
          @test_rule.stub!(:new).and_return(@test_rule)
          @test_rule.stub!(:title).and_return('mock title')
          @test_rule.stub!(:data=)
          RulesEngine::Discovery.stub!(:rule_class).with("one_one").and_return(@test_rule)
        end
        
        describe "rule returns nil" do
          it "should proceed to the next rule" do
            @test_rule.stub!(:process).and_return(nil)
            RulesEngine::Discovery.should_receive(:rule_class).with("one_two")
            @runner.run(10001, @plan, {})
          end
        end

        describe "rule returns NEXT" do
          it "should proceed to the next rule" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::NEXT))
            RulesEngine::Discovery.should_receive(:rule_class).with("one_two")
            @runner.run(10001, @plan, {})
          end
        end
        
        describe "rule returns STOP_SUCCESS" do
          it "should not proceed to the next rule" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS))
            RulesEngine::Discovery.should_not_receive(:rule_class).with("one_two")
            @runner.run(10001, @plan, {})
          end

          it "should return success" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_SUCCESS))
            @runner.run(10001, @plan, {}) == true
          end
        end

        describe "rule returns STOP_FAILURE" do
          it "should not proceed to the next rule" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE))
            RulesEngine::Discovery.should_not_receive(:rule_class).with("one_two")
            @runner.run(10001, @plan, {})
          end

          it "should return failure" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::STOP_FAILURE))
            @runner.run(10001, @plan, {}) == false
          end
        end

        describe "rule returns START_WORKFLOW" do
          it "should not proceed to the next rule" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, 'three'))
            RulesEngine::Discovery.should_not_receive(:rule_class).with("one_two")
            @runner.run(10001, @plan, {})
          end

          it "should start the defined workflow" do
            @test_rule.stub!(:process).and_return(RulesEngine::Rule::Outcome.new(RulesEngine::Rule::Outcome::START_WORKFLOW, 'three'))
            RulesEngine::Discovery.should_not_receive(:rule_class).with("two_one")
            RulesEngine::Discovery.should_receive(:rule_class).with("three_one")
            @runner.run(10001, @plan, {})
          end
        end
      end
    end
  end
  
end
