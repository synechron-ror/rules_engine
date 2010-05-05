require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# require File.expand_path(File.dirname(__FILE__) + '/re_pipeline_base_spec')

describe RePipeline do
  def valid_attributes
    {
      :code => "AA-MOCK",
      :title => "Mock Title"
    }
  end
  
  should_have_one :activated_re_pipeline
  should_have_many :re_job_audits
  
  describe "setting the activated status" do
    before(:each) do
      @re_pipeline = RePipeline.new(valid_attributes)
      @re_pipeline_activated = RePipeline.new(valid_attributes)
      @re_pipeline.stub!(:activated_re_pipeline).and_return(@re_pipeline_activated)
    end

    it "should be set to draft when there is no activated re_pipeline" do
      @re_pipeline.stub!(:activated_re_pipeline).and_return(nil)
      @re_pipeline.stub!(:validate).and_return(true)
      @re_pipeline.save
      @re_pipeline.activated_status.should == RePipelineBase::ACTIVATED_STATUS_DRAFT
    end

    it "should be active if there is an activated re_pipeline" do
      @re_pipeline.stub!(:validate).and_return(true)
      @re_pipeline.save
      @re_pipeline.activated_status.should == RePipelineBase::ACTIVATED_STATUS_ACTIVE
    end
  end
    
  describe "setting the changed status" do
    before(:each) do
      @re_pipeline = RePipeline.new(valid_attributes)
      @re_pipeline_activated = RePipeline.new(valid_attributes)
      @re_pipeline.stub!(:activated_re_pipeline).and_return(@re_pipeline_activated)
    end
    
    it "should be set to draft when there is no activated re_pipeline" do
      @re_pipeline.stub!(:activated_re_pipeline).and_return(nil)
      @re_pipeline.stub!(:validate).and_return(true)
      @re_pipeline.save
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_DRAFT
    end
    
    it "should be set to changed if the activated re_pipeline is not equal" do
      @re_pipeline.should_receive(:equals?).with(@re_pipeline_activated).and_return(false)      
      @re_pipeline.save
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CHANGED
    end
  end
  

  describe "activating a re_pipeline" do
    before(:each) do
      @re_pipeline = RePipeline.new(valid_attributes)
      @re_pipeline_activated = RePipelineActivated.new
      RePipelineActivated.stub!(:new).and_return(@re_pipeline_activated)
    end
        
    it "should create an associated activated re_pipeline if it does not exist" do
      RePipelineActivated.should_receive(:new).and_return(@re_pipeline_activated)
      @re_pipeline.activate!
    end

    it "should update the activated_status to RePipelineBase::ACTIVATED_STATUS_ACTIVE" do
      @re_pipeline.activate!
      @re_pipeline.activated_status.should == RePipelineBase::ACTIVATED_STATUS_ACTIVE
    end

    it "should update the changed_status to RePipelineBase::CHANGED_STATUS_CURRENT" do
      @re_pipeline.activate!
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CURRENT
    end

    it "should copy itself to the activated re_pipeline" do
      @re_pipeline_activated.should_receive(:copy!).with(@re_pipeline)
      @re_pipeline.activate!
    end

    it "should save the re_pipeline" do
      @re_pipeline.should_receive(:save)
      @re_pipeline.activate!
    end
    
    it "should do the saving in a transaction" do
      RePipeline.should_receive(:transaction)
      @re_pipeline.should_not_receive(:save)
      @re_pipeline.activate!
    end
        
    it "should save the activated re_pipeline if it is not a new record" do
      @re_pipeline.should_receive(:new_record?).at_least(:once).and_return(false)
      @re_pipeline_activated.should_receive(:save!)
      @re_pipeline.activate!
    end

    it "should not save the activated re_pipeline if it is a new record" do
      @re_pipeline.should_receive(:new_record?).at_least(:once).and_return(true)
      @re_pipeline_activated.should_not_receive(:save!)
      @re_pipeline.activate!
    end
  end
  
  describe "deactivating a pipeline" do
    before(:each) do
      @re_pipeline = RePipeline.new(valid_attributes)
      @re_pipeline_activated = RePipelineActivated.new
      @re_pipeline.activated_re_pipeline = @re_pipeline_activated
      @re_pipeline_activated.stub!(:destroy)
    end
        
    it "should destroy the activated pipeline" do
      @re_pipeline_activated.should_receive(:destroy)
      @re_pipeline.deactivate!
    end

    it "should not destroy the activated pipeline if not set" do
      @re_pipeline.activated_re_pipeline = nil
      @re_pipeline.deactivate!
    end
        
    it "should set the activated_re_pipeline to nil" do
      @re_pipeline.activated_re_pipeline.should_not be_nil
      @re_pipeline.deactivate!
      @re_pipeline.activated_re_pipeline.should be_nil
    end
    
    it "should save the pipeline" do
      @re_pipeline.should_receive(:save)
      @re_pipeline.deactivate!
    end
            
    
  end
  
  describe "reverting a re_pipeline to it's previous state" do
    before(:each) do
      @re_pipeline = RePipeline.create(valid_attributes)
      @re_pipeline.activate!
      @re_pipeline_activated = @re_pipeline.activated_re_pipeline
      
      @re_pipeline.update_attributes(:title => "new title")
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CHANGED
    end

    it "should copy the content from the activated re_pipeline" do
      @re_pipeline.should_receive(:copy!).with(@re_pipeline_activated)
      @re_pipeline.revert!
    end

    it "should not try and copy content id there is no activated re_pipeline" do
      @re_pipeline.stub!(:activated_re_pipeline).and_return(nil)      
      @re_pipeline.should_not_receive(:copy!)
      @re_pipeline.revert!
    end
        
    it "should save the re_pipeline" do
      @re_pipeline.should_receive(:save)
      @re_pipeline.revert!
    end
    
    it "should update the activated_status to RePipelineBase::ACTIVATED_STATUS_ACTIVE" do
      @re_pipeline.revert!
      @re_pipeline.activated_status.should == RePipelineBase::ACTIVATED_STATUS_ACTIVE
    end

    it "should update the changed_status to RePipelineBase::CHANGED_STATUS_CURRENT" do
      @re_pipeline.revert!
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CURRENT
    end    
  end
  
  describe "changing a re_pipeline" do
    before(:each) do
      @re_pipeline = RePipeline.create(valid_attributes)
      @re_pipeline.activate!
      @re_pipeline_activated = @re_pipeline.activated_re_pipeline
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CURRENT
    end
        
    it "should update the activated_status to RePipelineBase::ACTIVATED_STATUS_ACTIVE" do
      @re_pipeline.update_attributes(:title => "new title")
      @re_pipeline.activated_status.should == RePipelineBase::ACTIVATED_STATUS_ACTIVE
    end

    it "should update the changed_status to RePipelineBase::CHANGED_STATUS_CHANGED" do
      @re_pipeline.update_attributes(:title => "new title")
      @re_pipeline.changed_status.should == RePipelineBase::CHANGED_STATUS_CHANGED
    end
    
  end
  
end
