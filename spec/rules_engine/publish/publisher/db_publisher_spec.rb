require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "RulesEngine::Publish::RePublishedPlan" do
  before(:each) do
    RulesEngine::Publish.publisher = :db_publisher

    @re_published_plan_1 = RulesEngine::Publish::RePublishedPlan.create(:plan_code => 'mock_code', 
                                                                         :plan_version => 1,
                                                                         :version_tag => 'mock_tag', 
                                                                         :data => '["mock data"]')

    @re_published_plan_2 = RulesEngine::Publish::RePublishedPlan.create(:plan_code => 'mock_code', 
                                                                         :plan_version => 2,
                                                                         :version_tag => 'mock_tag', 
                                                                         :data => '["mock data"]')

    @re_published_plan_3 = RulesEngine::Publish::RePublishedPlan.create(:plan_code => 'other_code', 
                                                                         :plan_version => 1,
                                                                         :version_tag => 'other_code_tag', 
                                                                         :data => '["not found data"]')
                                                 
  end
  
  describe "plan" do
    it "should return the latest version" do
      RulesEngine::Publish::RePublishedPlan.plan('mock_code').should == @re_published_plan_2
      RulesEngine::Publish::RePublishedPlan.plan('mock_code', :version => nil).should == @re_published_plan_2
    end        

    it "should return the version requested" do
      RulesEngine::Publish::RePublishedPlan.plan('mock_code', :version => 1).should == @re_published_plan_1
    end        

    it "should return nil if the plan was not found" do
      RulesEngine::Publish::RePublishedPlan.plan('mock_code', :version => 3).should be_nil
      RulesEngine::Publish::RePublishedPlan.plan('not_a_code').should be_nil
    end        
  end

  describe "plans" do
    it "should return the latest version" do
      RulesEngine::Publish::RePublishedPlan.plans('mock_code').should == [@re_published_plan_2, @re_published_plan_1]
      RulesEngine::Publish::RePublishedPlan.plans('other_code').should == [@re_published_plan_3]
    end        

    it "should return an empty array if the plan was not found" do
      RulesEngine::Publish::RePublishedPlan.plans('dummy').should == []
    end        
  end  
end

describe "RulesEngine::Publish::DbPublisher" do
  before(:each) do
    RulesEngine::Publish.publisher = :db_publisher
    
    @now = Time.now
    @re_published_plan = mock_model(RulesEngine::Publish::RePublishedPlan)
    @re_published_plan.stub!(:plan_version).and_return(101)
    @re_published_plan.stub!(:version_tag).and_return("tag 101")
    @re_published_plan.stub!(:published_at).and_return(@now)
    @re_published_plan.stub!(:data).and_return('["mock json data"]')

    RulesEngine::Publish::RePublishedPlan.stub!(:create)
    RulesEngine::Publish::RePublishedPlan.stub!(:plan).and_return(@re_published_plan)    
    RulesEngine::Publish::RePublishedPlan.stub!(:plans).and_return([@re_published_plan, @re_published_plan])    
    
    
    @store = mock('cache store')
    @store.stub!(:read)
    @store.stub!(:write)
    RulesEngine::Cache.stub!(:cache_store).and_return(@store)    
    RulesEngine::Cache.stub!(:perform_caching?).and_return(false)    
  end
  
  describe "setting the publisher" do
    it "should set the publisher to the database plan publisher" do
      RulesEngine::Publish.publisher.should be_instance_of(RulesEngine::Publish::DbPublisher)
    end
  end
  
  describe "publishing a plan" do
    
    describe "writing the plan to the database" do
      it "should create a new plan with the code and the data" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:create).with(hash_including(:plan_code => 'mock_code', :version_tag => 'mock_tag'))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should create a set the plan code in the data" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:create) do |options| 
          JSON.parse(options[:data])["code"].should == "mock_code"
        end
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should create a set the plan version in the data" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:create) do |options| 
          JSON.parse(options[:data])["version"].should == 102
        end
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should create a set the plan tag in the data" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:create) do |options| 
          JSON.parse(options[:data])["tag"].should == 'mock_tag'
        end
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should set the published_at time to now utc" do
        now = Time.now
        Time.stub!(:now).and_return(now)
        RulesEngine::Publish::RePublishedPlan.should_receive(:create).with(hash_including(:published_at => now.utc))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end
    
      describe "no existing plan" do
        it "should set the plan_version as 1" do
          RulesEngine::Publish::RePublishedPlan.stub!(:plan).and_return(nil)    
          RulesEngine::Publish::RePublishedPlan.should_receive(:create).with(hash_including(:plan_version => 1))
          RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
        end
      end    
    
      describe "existing plan" do
        it "should increment the plan_version" do
          RulesEngine::Publish::RePublishedPlan.stub!(:plan).and_return(@re_published_plan)
          RulesEngine::Publish::RePublishedPlan.should_receive(:create).with(hash_including(:plan_version => 102))
          RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
        end
      end
    end
    
    it "should return the version" do
      RulesEngine::Publish::RePublishedPlan.stub!(:plan).and_return(@re_published_plan)
      
      @re_published_plan.stub!(:plan_version).and_return(101)
      RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'}).should == 102

      @re_published_plan.stub!(:plan_version).and_return(333)
      RulesEngine::Publish.publisher.stub!(:get_re_plan).and_return(@re_published_plan)
      RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'}).should == 334
    end

    describe "caching turned on" do
      before(:each) do
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)        
      end
      
      it "should write the plan to the cache" do
        @store.should_receive(:write).with('re_db_pub_mock_code_default', hash_including("data" => 'mock'))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end          

      it "should set the plan code in the data" do
        @store.should_receive(:write).with('re_db_pub_mock_code_default', hash_including("code" => 'mock_code'))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should set the plan version in the data" do
        @store.should_receive(:write).with('re_db_pub_mock_code_default', hash_including("version" => 102))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end

      it "should set the plan tag in the data" do
        @store.should_receive(:write).with('re_db_pub_mock_code_default', hash_including("tag" => 'mock_tag'))
        RulesEngine::Publish.publisher.publish('mock_code', 'mock_tag', {"data" => 'mock'})
      end
    end
  end

  describe "getting a plan" do

    describe "no caching" do
      it "should get the plan from the database" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:plan).with("mock_code", {:version => 101}).and_return(@re_published_plan)    
        RulesEngine::Publish.publisher.get("mock_code", 101).should == ["mock json data"]
      end
    end
    
    describe "caching turned on" do
      before(:each) do
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      end
      
      describe "plan in the cache" do
        it "should return the cached plan" do
          @store.should_receive(:read).with("re_db_pub_mock_code_101").and_return('mock cache data')
          RulesEngine::Publish.publisher.get("mock_code", 101).should == 'mock cache data'
        end        
      end
      
      describe "plan not in the cache" do
        before(:each) do
          @store.should_receive(:read).and_return(nil)
        end

        it "should use get the plan from the database" do
          RulesEngine::Publish::RePublishedPlan.should_receive(:plan).with("mock_code", {:version => 101}).and_return(@re_published_plan)
          RulesEngine::Publish.publisher.get("mock_code", 101).should == ["mock json data"]
        end
        
        it "should write the plan to the cache" do
          @store.should_receive(:write).with('re_db_pub_mock_code_101', ['mock json data'])
          RulesEngine::Publish.publisher.get("mock_code", 101)
        end
      end    
    end
  end
  
  describe "getting the publication history" do
    it "should returns a hash of the version data " do
      data = RulesEngine::Publish.publisher.history('mock_code')
      data.should be_instance_of(Hash)
    end
    
    it "should include an array of publications" do
      data = RulesEngine::Publish.publisher.history('mock_code')
      versions = data["publications"]
      versions.should be_instance_of(Array)
    end  
    
    it "should include the publication information" do
      data = RulesEngine::Publish.publisher.history('mock_code')
      publications = data["publications"]
      
      publications.length.should == 2
      publications[0]["plan_version"].should == 101
      publications[0]["version_tag"].should == "tag 101"
      publications[0]["published_at"].should == @now.utc.to_s
  
      publications[1]["plan_version"].should == 101
      publications[1]["version_tag"].should == "tag 101"
      publications[1]["published_at"].should == @now.utc.to_s
    end
  end
  
  describe "removing a plan" do
    before(:each) do
      @re_published_plan.stub!(:destroy)
    end
    
    describe "getting the plans from the database" do
      it "should get all versions" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:plans).with("mock_code")
        RulesEngine::Publish.publisher.remove("mock_code")
      end

      it "should get the requested version" do
        RulesEngine::Publish::RePublishedPlan.should_receive(:plan).with("mock_code", {:version => 101})
        RulesEngine::Publish.publisher.remove("mock_code", 101)
      end
    end
        
    it "should remove all of the re_published_plans" do
      @re_published_plan.should_receive(:destroy).twice
      RulesEngine::Publish.publisher.remove('mock_code')
    end
        
    describe "no caching" do
      it "should not reset the cache store" do
        RulesEngine::Cache.stub!(:perform_caching?).and_return(false)    
        @store.should_not_receive(:delete)
        RulesEngine::Publish.publisher.remove('mock_code')
      end
    end
      
    describe "caching turned on" do
      before(:each) do
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      end
      
      it "should reset the cache for all versions" do
        @store.should_receive(:delete).with('re_db_pub_mock_code_101').twice
        @store.should_receive(:delete).with('re_db_pub_mock_code_default')
        RulesEngine::Publish.publisher.remove('mock_code')      
      end
    end
  end
end
