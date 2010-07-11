require File.dirname(__FILE__) + '/../spec_helper'

class MockModelLoaderController < ActionController::Base
end

describe "RulesEngineView::ModelLoader", :type => :controller  do
  controller_name 'MockModelLoader'

  before(:each) do
    @target = mock("Target")
    @target.stub(:parent_id).and_return('101')
    
    Kernel.stub(:const_get).with('Target').and_return(@target_class = mock('TargetClass'))
    @target_class.stub(:send).with(:find, "mock_id").and_return(@target)
    
    controller.instance_variable_set('@parent', @parent = mock('Parent'))
    @parent.stub(:id).and_return('101')      
    
    controller.stub(:targets_path).and_return('/targets')
    controller.stub(:redirect_to)
    controller.stub(:params).and_return(:id => 'mock_id')
    format = mock("format") 
    format.stub(:js).and_return(controller)
    format.stub(:html).and_yield(controller)
    controller.stub(:respond_to).and_yield(format)
  end
  
  describe "loading a valid model" do
    it "should find the model" do
      @target_class.should_receive(:send).with(:find, "mock_id").and_return(@target)      
      controller.re_load_model('target').should
    end
        
    it "should set the instance variable '@model'" do
      controller.re_load_model('target')
      controller.instance_variable_get('@target').should == @target
    end
  end
  
  describe "loading an invalid model" do
    before(:each) do
      @target_class.stub(:send).with(:find, "mock_id").and_return(nil)
    end
    
    it "should set the inastance variable '@model' to nil" do
      controller.re_load_model('target')
      controller.instance_variable_get('@target').should == nil
    end
    
    it "should set the error message" do
      controller.re_load_model('target')      
      flash[:error].should_not be_blank      
    end        
    
    it "should redirect to the index path of the model" do
      controller.should_receive(:redirect_to).with('/targets')
      controller.re_load_model('target')
    end   
    
    it "should set the javascript redirect to the index path of the model" do
      result = ""
      format = mock("format", :html => "html") 
      controller.should_receive(:respond_to).and_yield(format)
      format.should_receive(:js).and_yield
      controller.should_receive(:render).with(:update).and_yield(result)
      
      controller.re_load_model('target')
      result.should == "window.location.href = '\/targets';"
    end
                       
  end
  
  describe "the model has valid parents" do
    it "should confirm that this model is a child of the direct parent" do
      @target.should_receive(:parent_id).and_return('101')
      controller.re_load_model('target', :parents => ['parent'])
      controller.instance_variable_get('@target').should == @target
    end
    
    it "should use the :validate method if set" do
      @target.should_receive(:validate_method).with(@parent).and_return(true)
      controller.re_load_model('target', :validate => "validate_method", :parents => ['parent'])
      controller.instance_variable_get('@target').should == @target
    end
        
  end
  
  describe "the model is not a child of the direct parent" do
    before(:each) do
      @target.stub!(:parent_id).and_return('202')
    end
    
    it "should set the inastance variable '@model' to nil" do      
      controller.re_load_model('target', :parents => ['parent'])
      controller.instance_variable_get('@target').should == nil
    end
  
    it "should set the error message" do
      controller.re_load_model('target', :parents => ['parent'])      
      flash[:error].should_not be_blank
    end        
    
    it "should redirect to the index path of the parent" do
      controller.should_receive(:parents_path).with([@parent]).and_return('/parent/202') 
      controller.should_receive(:redirect_to).with('/parent/202')
      controller.re_load_model('target', :parents => ['parent'], :redirect_path => 'parents_path')
    end        
    
    it "should set the javascript redirect to the path of the parent" do
      result = ""
      format = mock("format", :html => "html") 
      controller.should_receive(:respond_to).and_yield(format)
      format.should_receive(:js).and_yield
      controller.should_receive(:render).with(:update).and_yield(result)
      
      controller.should_receive(:parents_path).with([@parent]).and_return('/parent/202') 
      controller.re_load_model('target', :parents => ['parent'], :redirect_path => 'parents_path')
      result.should == "window.location.href = '\/parent\/202';"
    end
        
  end
  
  describe "finding a model" do
    it "should call find when the parameter :find is not set" do
      @target_class.should_receive(:send).with(:find, "mock_id").and_return(@target)
      controller.re_load_model('target')
    end
    
    it "should use the parameter :find when set" do
      @target_class.should_receive(:send).with(:find_by_mock, "mock_id").and_return(@target)
      controller.re_load_model('target', :find_by => :find_by_mock)
    end
            
    it "should use id when the the parameter :id is not set" do
      @target_class.should_receive(:send).with(:find, "test_mock_id").and_return(@target)
      
      controller.stub(:params).and_return(:id => 'test_mock_id')
      controller.re_load_model('target')
    end
    
    it "should use the parameter :id when set" do
      @target_class.should_receive(:send).with(:find, "test_mock_id").and_return(@target)
      
      controller.stub(:params).and_return(:mock_id_field => 'test_mock_id')
      controller.re_load_model('target', :param_id => :mock_id_field)
    end
  
    it "should capture RecordNotFound exceptions and return nil" do
      @target_class.should_receive(:send).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        controller.re_load_model('target')
      }.should_not raise_error
      
      controller.instance_variable_get('@target').should == nil
    end
  end
  
  describe "redirecting on failure" do
    before(:each) do
      @target_class.should_receive(:send).with(:find, "mock_id").and_return(nil)
    end
    it "should call the model's index path the parameter :redirect_path is not set" do
      controller.should_receive(:targets_path)
      controller.re_load_model('target')
    end
    
    it "should use the :redirect_path when set" do
      controller.should_receive(:mock_redirect)
      controller.re_load_model('target', :redirect_path => :mock_redirect)
    end
        
    it "should pass an array of parent models when the :parents set and :redirect_path set" do
      controller.should_receive(:mock_redirect).with([@parent])
      controller.re_load_model('target', :redirect_path => :mock_redirect, :parents => [:parent])
    end
  end
end