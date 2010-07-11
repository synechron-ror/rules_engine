require File.dirname(__FILE__) + '/../spec_helper'

describe RePipelineHelper do 
  
  before(:each) do
    @re_pipeline = mock("RePipeline")
  end
  
  it "should be 'draft' when changed status is CHANGED_STATUS_DRAFT" do
    @re_pipeline.should_receive(:changed_status).and_return(RePipelineBase::CHANGED_STATUS_DRAFT)
    helper.re_pipeline_status(@re_pipeline).should == 'draft'
  end

  it "should be 'changed' when changed status is CHANGED_STATUS_CHANGED" do
    @re_pipeline.should_receive(:changed_status).and_return(RePipelineBase::CHANGED_STATUS_CHANGED)
    helper.re_pipeline_status(@re_pipeline).should == 'changed'
  end

  it "should be 'current' when changed status is CHANGED_STATUS_CURRENT" do
    @re_pipeline.should_receive(:changed_status).and_return(RePipelineBase::CHANGED_STATUS_CURRENT)
    helper.re_pipeline_status(@re_pipeline).should == 'current'
  end

  it "should be 'current' when changed status is unknown" do
    @re_pipeline.should_receive(:changed_status).and_return(20202020202)
    helper.re_pipeline_status(@re_pipeline).should == 'current'
  end
      
end
