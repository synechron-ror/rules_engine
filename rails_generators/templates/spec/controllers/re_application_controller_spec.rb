require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MockRulesEngineController < ApplicationController
  before_filter :rules_engine_editor_access_required,  :only => [:editor]
  before_filter :rules_engine_reader_access_required,  :only => [:reader]
  
  def editor    
  end
  
  def reader    
  end
end

describe "ReApplicationController", :type => :controller  do
  controller_name 'MockRulesEngine'
  
  describe "editor" do
    describe "editor access enabled" do
      it "should be successfull with rules_engine_editor true" do
        controller.stub(:cookies).and_return(:rules_engine_editor => 'true')
        get :editor
        response.should be_success
        response.should render_template('editor')
      end

      it "should be successfull with rules_engine_editor nil" do
        controller.stub(:cookies).and_return({})
        get :editor
        response.should be_success
        response.should render_template('editor')
      end          
    end
    
    describe "editor access disabled" do
      it "should redirect to the root path" do
        controller.stub(:cookies).and_return(:rules_engine_editor => 'false')
        get :editor
        response.should redirect_to(root_path)
      end
    end  
  end  

  describe "reader" do
    describe "reder access enabled" do
      it "should be successfull with rules_engine_reader true" do
        controller.stub(:cookies).and_return(:rules_engine_reader => 'true')
        get :reader
        response.should be_success
        response.should render_template('reader')
      end

      it "should be successfull with rules_engine_reader nil" do
        controller.stub(:cookies).and_return({})
        get :reader
        response.should be_success
        response.should render_template('reader')
      end          
    end
    
    describe "reader access disabled" do
      it "should redirect to the root path" do
        controller.stub(:cookies).and_return(:rules_engine_reader => 'false')
        get :reader
        response.should redirect_to(root_path)
      end
    end  
  end    
end
