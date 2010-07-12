require File.dirname(__FILE__) + '/../spec_helper'

describe RulesEngineHelper do 
  
  before(:each) do
    @re_plan = mock("RePlan")
  end
  
  it "should be 'draft' when changed status is PLAN_STATUS_DRAFT" do
    @re_plan.should_receive(:status).and_return(RePlan::PLAN_STATUS_DRAFT)
    helper.re_plan_status(@re_plan).should == 'draft'
  end

  it "should be 'changed' when changed status is PLAN_STATUS_CHANGED" do
    @re_plan.should_receive(:status).and_return(RePlan::PLAN_STATUS_CHANGED)
    helper.re_plan_status(@re_plan).should == 'changed'
  end

  it "should be 'published' when changed status is PLAN_STATUS_PUBLISHED" do
    @re_plan.should_receive(:status).and_return(RePlan::PLAN_STATUS_PUBLISHED)
    helper.re_plan_status(@re_plan).should == 'published'
  end

  it "should be 'draft' when changed status is unknown" do
    @re_plan.should_receive(:status).and_return(20202020202)
    helper.re_plan_status(@re_plan).should == 'draft'
  end
      
end
