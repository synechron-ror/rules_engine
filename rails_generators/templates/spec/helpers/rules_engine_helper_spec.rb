require File.dirname(__FILE__) + '/../spec_helper'

describe RulesEngineHelper do 
  
  before(:each) do
    @re_plan = mock("RePlan")
  end

  describe "re_plan_status" do
    it "should be 'draft' when changed status is PLAN_STATUS_DRAFT" do
      @re_plan.should_receive(:plan_status).and_return(RePlan::PLAN_STATUS_DRAFT)
      helper.re_plan_status(@re_plan).should == 'draft'
    end

    it "should be 'changed' when changed status is PLAN_STATUS_CHANGED" do
      @re_plan.should_receive(:plan_status).and_return(RePlan::PLAN_STATUS_CHANGED)
      helper.re_plan_status(@re_plan).should == 'changed'
    end

    it "should be 'published' when changed status is PLAN_STATUS_PUBLISHED" do
      @re_plan.should_receive(:plan_status).and_return(RePlan::PLAN_STATUS_PUBLISHED)
      helper.re_plan_status(@re_plan).should == 'published'
    end

    it "should be 'draft' when changed status is unknown" do
      @re_plan.should_receive(:plan_status).and_return(20202020202)
      helper.re_plan_status(@re_plan).should == 'draft'
    end
  end

  describe "re_plan_version" do
    it "should be blank when there is no plan" do
      helper.re_plan_version(nil).should == ''
    end

    it "should return an abriviated plan version" do
      @re_plan.stub!(:plan_version).and_return(1001)
      helper.re_plan_version(@re_plan).should == 'Ver.1001'
    end
  end

  describe "re_perocess_status" do
    it "should running" do
      helper.re_process_status(RulesEngine::Process::PROCESS_STATUS_RUNNING).should == 'running'
    end
    
    it "should be success" do
      helper.re_process_status(RulesEngine::Process::PROCESS_STATUS_SUCCESS).should == 'success'
    end
    
    it "should be error" do
      helper.re_process_status(RulesEngine::Process::PROCESS_STATUS_FAILURE).should == 'error'
    end
    
    it "should be info" do
      helper.re_process_status(RulesEngine::Process::PROCESS_STATUS_NONE).should == 'info'
    end
    
    it "should accept string versions of the process status" do
      helper.re_process_status("#{RulesEngine::Process::PROCESS_STATUS_RUNNING}").should == 'running'
      helper.re_process_status("#{RulesEngine::Process::PROCESS_STATUS_SUCCESS}").should == 'success'
      helper.re_process_status("#{RulesEngine::Process::PROCESS_STATUS_FAILURE}").should == 'error'
      helper.re_process_status("#{RulesEngine::Process::PROCESS_STATUS_NONE}").should == 'info'
    end
  end    

  describe "re_audit_status" do
    it "should be success" do
      helper.re_audit_status(RulesEngine::Process::AUDIT_SUCCESS).should == 'success'
    end
    
    it "should be error" do
      helper.re_audit_status(RulesEngine::Process::AUDIT_FAILURE).should == 'error'
    end
    
    it "should be info" do
      helper.re_audit_status(RulesEngine::Process::AUDIT_INFO).should == 'info'
    end
    
    it "should accept string versions of the process status" do
      helper.re_audit_status("#{RulesEngine::Process::AUDIT_SUCCESS}").should == 'success'
      helper.re_audit_status("#{RulesEngine::Process::AUDIT_FAILURE}").should == 'error'
      helper.re_audit_status("#{RulesEngine::Process::AUDIT_INFO}").should == 'info'
    end
  end    
end
