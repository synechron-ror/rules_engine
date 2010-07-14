require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RulesEngine::Publish::Publisher" do

  describe "setting the publisher" do
    it "should set the publisher as a instance of a class" do
      mock_publisher = mock('mock_publisher')
      RulesEngine::Publish.publisher = mock_publisher
      RulesEngine::Publish.publisher.should == mock_publisher
    end

    it "should set the publisher to the database plan publisher" do
      RulesEngine::Publish.publisher = :db_publisher
      RulesEngine::Publish.publisher.should be_instance_of(RulesEngine::Publish::DbPublisher)
    end
  end
  
  describe "getting the publisher" do
    it "should throw an exception if the publisher is not set" do
      lambda {
        RulesEngine::Publish.publisher
      }.should raise_error
    end        
  end
  
  describe "publishing a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Publish::Publisher.new.publish('code', 'version_tag', 'data')
      }.should raise_error
    end
  end

  describe "getting a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Publish::Publisher.new.get('code', '1.0.0.1')
      }.should raise_error
    end
  end

  describe "getting the versions" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Publish::Publisher.new.versions('code', {:dummy => "option"})
      }.should raise_error
    end
  end
  
  describe "removing a plan" do
    it "should throw an error if not overwritten" do
      lambda {
        RulesEngine::Publish::Publisher.new.remove('code')
      }.should raise_error
      
      lambda {
        RulesEngine::Publish::Publisher.new.remove('code', 1)
      }.should raise_error
      
    end
  end
end
