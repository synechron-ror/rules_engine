require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ReApplicationController"  do

  controller(ApplicationController) do
    
    before_filter do |controller|
      controller.rules_engine_editor_access_required if params[:editor]
      controller.rules_engine_reader_access_required if params[:reader] 
    end
    
    def index    
      render :text => 'index_content'
    end
    
    def root_path
      "/root_path"
    end  
  end  
  
  describe "editor" do
    describe "editor access enabled" do
      it "should be successfull with rules_engine_editor true" do
        controller.stub(:cookies).and_return(:rules_engine_editor => 'true')
        get :index, :editor => true
        response.should be_success
        response.body.should =~ /index_content/
      end

      it "should be successfull with rules_engine_editor nil" do
        controller.stub(:cookies).and_return({})
        get :index, :editor => true
        response.should be_success
        response.body.should =~ /index_content/
      end          
    end
    
    describe "editor access disabled" do
      it "should redirect to the root path" do
        controller.stub(:cookies).and_return(:rules_engine_editor => 'false')
        get :index, :editor => true
        response.should redirect_to("/root_path")
      end
    end  
  end  

  describe "reader" do
    describe "reder access enabled" do
      it "should be successfull with rules_engine_reader true" do
        controller.stub(:cookies).and_return(:rules_engine_reader => 'true')
        get :index, :reader => true
        response.should be_success
        response.body.should =~ /index_content/
      end

      it "should be successfull with rules_engine_reader nil" do
        controller.stub(:cookies).and_return({})
        get :index, :reader => true
        response.should be_success
        response.body.should =~ /index_content/
      end          
    end
    
    describe "reader access disabled" do
      it "should redirect to the root path" do
        controller.stub(:cookies).and_return(:rules_engine_reader => 'false')
        get :index, :reader => true
        response.should redirect_to("/root_path")
      end
    end  
  end    
end
