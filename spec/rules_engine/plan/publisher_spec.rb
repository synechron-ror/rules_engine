require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Plan::Publisher" do

  describe "setting the publisher" do
    it "should set the publisher as a instance of a class" do
      mock_publisher = mock('mock_publisher')
      RulesEngine::Plan.publisher = mock_publisher
      RulesEngine::Plan.publisher.should == mock_publisher
    end

    it "should set the publisher to the database plan publisher" do
      RulesEngine::Plan.publisher = :db_publisher
      RulesEngine::Plan.publisher.should be_instance_of(RulesEngine::Plan::DbPublisher)
    end
  end
  
  describe "getting the publisher" do
    it "should throw an exception if the publisher is not set" do
      lambda {
        RulesEngine::Plan.publisher
      }.should raise_error
    end        
  end
  
  describe "publishing a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Plan::Publisher.new.publish('code', 'data')
      }.should raise_error
    end
  end

  describe "getting a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Plan::Publisher.new.get('code', '1.0.0.1')
      }.should raise_error
    end
  end

  describe "getting the versions" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Plan::Publisher.new.versions('code')
      }.should raise_error
    end
  end
  
  describe "removing a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Plan::Publisher.new.remove('code')
      }.should raise_error
      
      lambda {
        RulesEngine::Plan::Publisher.new.remove('code', 1)
      }.should raise_error
      
    end
  end
end
