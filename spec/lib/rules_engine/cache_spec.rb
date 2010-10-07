require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Cache" do

  it "should set perform caching to false if cahing not set" do
    RulesEngine::Cache.cache_store=nil
    RulesEngine::Cache.should_not be_perform_caching
  end
  
  it "should set the cache store using ActiveSupport::Cache.lookup_store" do
    ActiveSupport::Cache.should_receive(:lookup_store).with('test cache').and_return("mock store")    
    RulesEngine::Cache.cache_store="test cache"
    RulesEngine::Cache.cache_store.should == "mock store"
  end
  
end
