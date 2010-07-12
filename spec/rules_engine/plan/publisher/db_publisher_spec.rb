require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "RulesEngine::Plan::DbPublisher" do
  before(:each) do
    RulesEngine::Plan.publisher = :db_publisher
    
    RulesEngine::Plan::RePublishedPlan.stub!(:by_plan_code).and_return(RulesEngine::Plan::RePublishedPlan)
    RulesEngine::Plan::RePublishedPlan.stub!(:order_version).and_return(RulesEngine::Plan::RePublishedPlan)    
  end
  
  describe "setting the publisher" do
    it "should set the publisher to the database plan publisher" do
      RulesEngine::Plan.publisher.should be_instance_of(RulesEngine::Plan::DbPublisher)
    end
  end
  
  describe "publishing a plan" do
    before(:each) do
      @re_published_plan = mock_model(RulesEngine::Plan::RePublishedPlan)
      @re_published_plan.stub!(:version).and_return(1)
      RulesEngine::Plan.publisher.stub!(:get_re_plan).and_return(@re_published_plan)      
      RulesEngine::Cache.stub!(:perform_caching?).and_return(false)
    end
    
    it "should create a new plan with the code and the data" do
      RulesEngine::Plan::RePublishedPlan.should_receive(:create).with(hash_including(:plan_code => 'mock_code', :data => '["mock data"]'))
      RulesEngine::Plan.publisher.publish('mock_code', ['mock data'])
    end
        
    it "should set the version as 1 if not set" do
      RulesEngine::Plan.publisher.stub!(:get_re_plan).and_return(nil)
      RulesEngine::Plan::RePublishedPlan.should_receive(:create).with(hash_including(:version => 1))
      RulesEngine::Plan.publisher.publish('mock_code', 'mock data')
    end
    
    it "should increment the version if set" do
      @re_published_plan.stub!(:version).and_return(101)
      RulesEngine::Plan::RePublishedPlan.should_receive(:create).with(hash_including(:version => 102))
      RulesEngine::Plan.publisher.publish('mock_code', 'mock data')
    end

    it "should return the version" do
      RulesEngine::Plan::RePublishedPlan.stub!(:create)

      RulesEngine::Plan.publisher.stub!(:get_re_plan).and_return(nil)
      RulesEngine::Plan.publisher.publish('mock_code', 'mock data').should == 1

      @re_published_plan.stub!(:version).and_return(101)
      RulesEngine::Plan.publisher.stub!(:get_re_plan).and_return(@re_published_plan)
      RulesEngine::Plan.publisher.publish('mock_code', 'mock data').should == 102
    end

    it "should set the time to now utc" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      RulesEngine::Plan::RePublishedPlan.should_receive(:create).with(hash_including(:published_at => now.utc))
      RulesEngine::Plan.publisher.publish('mock_code', 'mock data')
    end
    
    describe "caching turned on" do
      it "should write the plan to the cache" do
        RulesEngine::Plan::RePublishedPlan.stub!(:create)
        
        store = mock('cache store')
        RulesEngine::Cache.stub!(:cache_store).and_return(store)
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
        
        store.should_receive(:write).with('re_db_pub_mock_code_default', 'mock data')
        RulesEngine::Plan.publisher.publish('mock_code', 'mock data')
      end
          
    end
  end

  describe "getting a plan" do
    describe "no caching" do
      it "should use get_without_caching" do
        RulesEngine::Cache.stub!(:perform_caching?).and_return(false)
        RulesEngine::Plan.publisher.should_receive(:get_without_caching).with("mock_code", 101)
        RulesEngine::Plan.publisher.get("mock_code", 101)
      end
    end
    
    describe "caching" do
      before(:each) do
        @store = mock('cache store')
        RulesEngine::Cache.stub!(:cache_store).and_return(@store)
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      end
      
      it "should read the cache" do
        @store.should_receive(:read).with("re_db_pub_mock_code_101").and_return('mock data')
        RulesEngine::Plan.publisher.get("mock_code", 101).should == 'mock data'
      end
      
      describe "no plan in cache" do
        before(:each) do
          @store.stub!(:read).with("re_db_pub_mock_code_101").and_return(nil)
          @store.stub!(:write)
          RulesEngine::Plan.publisher.stub!(:get_without_caching).and_return(['mock data'])                
        end
        
        it "should use get_without_caching" do
          RulesEngine::Plan.publisher.should_receive(:get_without_caching)
          RulesEngine::Plan.publisher.get("mock_code", 101)
        end
        
        it "should write the plan to the cache" do
          @store.should_receive(:write).with('re_db_pub_mock_code_101', ['mock data'])
          RulesEngine::Plan.publisher.get("mock_code", 101)
        end
      end    
    end
  end

  describe "getting the versions" do
    it "should returns an array of version data " do
      now = Time.now
      plan_1 = mock('RePublishedPlan', :version => 101, :published_at => now)
      plan_2 = mock('RePublishedPlan', :version => 102, :published_at => now + 5.days)
      
      RulesEngine::Plan::RePublishedPlan.stub!(:find).and_return([plan_1, plan_2])
                                              
      versions = RulesEngine::Plan.publisher.versions('mock_code')
      versions.length.should == 2
      versions[0][:version].should == 101
      versions[0][:published_at].should == now.utc.to_s

      versions[1][:version].should == 102
      versions[1][:published_at].should == (now + 5.days).utc.to_s
    end
  end
  
  describe "removing the plans" do
    before(:each) do
      @plan_1 = mock('RePublishedPlan', :version => 101)
      @plan_2 = mock('RePublishedPlan', :version => 102)
  
      @plan_1.stub!(:destroy)
      @plan_2.stub!(:destroy)
      
      RulesEngine::Plan::RePublishedPlan.stub!(:find).and_return([@plan_1, @plan_2])
      RulesEngine::Cache.stub!(:perform_caching?).and_return(false)
    end
    
    describe "no version defined" do
      it "should remove all of the plans" do
        @plan_1.should_receive(:destroy)
        @plan_2.should_receive(:destroy)
        versions = RulesEngine::Plan.publisher.remove('mock_code')
      end
    
      it "should reset the cache" do
        store = mock('cache store')
        RulesEngine::Cache.stub!(:cache_store).and_return(store)
        RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      
        store.should_receive(:delete).with('re_db_pub_mock_code_101')
        store.should_receive(:delete).with('re_db_pub_mock_code_102')
        store.should_receive(:delete).with('re_db_pub_mock_code_default')
        versions = RulesEngine::Plan.publisher.remove('mock_code')      
      end
    end
    
    describe "version defined" do
      it "should find by version" do
        RulesEngine::Plan::RePublishedPlan.stub!(:by_version).with(101).and_return(RulesEngine::Plan::RePublishedPlan)
        RulesEngine::Plan.publisher.remove('mock_code', 101)      
      end
    end    
  end

  describe "getting the cache code" do
    it "should prefix with re_plan" do
      pending("needs to be written")
    end
        
    it "should replace any nonprint characters with _" do
      pending("needs to be written")
    end
            
    it "should append with the version number or default" do
      pending("needs to be written")
    end
  end
  
  describe "get_without_caching" do
    it "should get the re_plan" do
      pending("needs to be written")
    end
    
    describe "plan found" do
      it "should return the data" do
        pending("needs to be written")
      end          
    end    
    
    describe "plan not found" do
      it "should return nil" do
        pending("needs to be written")
      end          
    end
  end
  
  describe "get_re_plan" do
    it "should get by plan_code" do
      pending("needs to be written")
    end
    
    it "should get by version" do
      pending("needs to be written")
    end
    
    it "should order by version DESC" do
      pending("needs to be written")
    end
    
    it "should return the first record" do
      pending("needs to be written")
    end
  end
end
