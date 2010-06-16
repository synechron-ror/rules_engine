require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePipelineActivated do

  should_belong_to :re_pipeline, :foreign_key => :parent_re_pipeline_id
  
  
  describe "find_by_code" do
    before(:each) do
      RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      
      @cache = mock("Cache")
      @cache.stub!(:read)
      @cache.stub!(:write)
      RulesEngine::Cache.stub!(:cache_store).and_return(@cache)
    end
    
    it "should not use the cache if cache not set" do
      RulesEngine::Cache.stub!(:perform_caching?).and_return(false)
      RePipelineActivated.should_receive(:find_by_code_without_caching)
      RePipelineActivated.find_by_code("mock_code")
    end
    
    it "should return the pipeline found in the cache" do
      @cache.should_receive(:read).and_return("cache result")
      RePipelineActivated.find_by_code("mock_code").should == "cache result"      
    end

    it "should look for the pipeline if not found in the cache" do      
      RePipelineActivated.should_receive(:find_by_code_without_caching).and_return("db result") 
      RePipelineActivated.find_by_code("mock_code").should == "db result"      
    end

    it "should add the pipeline to the cache" do      
      RePipelineActivated.should_receive(:find_by_code_without_caching).and_return("db result") 
      @cache.stub!(:write).with(anything, "db result")
      RePipelineActivated.find_by_code("mock_code").should == "db result"      
    end
  end
  
  describe "find_without caching" do
    it "should lookup the pipeline in the database" do
      RePipelineActivated.should_receive(:find).with(:first, anything)
      RePipelineActivated.find_by_code_without_caching("mock_code")
    end
  end    

  describe "resetting the cache" do
    before(:each) do
      RulesEngine::Cache.stub!(:perform_caching?).and_return(true)
      
      @cache = mock("Cache")
      @cache.stub!(:delete)
      RulesEngine::Cache.stub!(:cache_store).and_return(@cache)      
    end
    
    it "should ignore if caching is not on" do
      RulesEngine::Cache.stub!(:perform_caching?).and_return(false)
      RulesEngine::Cache.should_not_receive(:cache_store)
      
      RePipelineActivated.reset_cache("mock_code")
    end
    
    it "reset the cache entry" do
      @cache.should_receive(:delete)
      
      RePipelineActivated.reset_cache("mock_code")
    end    
  end  
    
end
