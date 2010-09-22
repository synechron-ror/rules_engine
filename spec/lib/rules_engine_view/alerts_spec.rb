require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "re_error_on" do 
  include RSpec::Rails::HelperExampleGroup

  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_alert")
  end
  
  describe "no error" do
    before(:each) do
      @model = mock('model')
      @model.stub!(:errors).and_return({})      
    end

    it "should be blank" do
      helper.re_error_on(@model, "The Error Message to Show").should be_blank
    end      
  end

  describe "has errors error" do
    before(:each) do
      @model = mock('model')
      @model.stub!(:errors).and_return({:opps => "something wen wrong"})      
    end

    it "should be html safe" do
      helper.re_error_on(@model, "The Error Message to Show").should be_html_safe
      helper.re_error_on(@model, "<The Error Message to Show>").should have_selector('div.re-error > p') do |error_message|
        error_message.inner_html.should == "&lt;The Error Message to Show&gt;"
      end
    end  
        
    it "should display the error" do
      helper.re_error_on(@model, "The Error Message to Show").should have_selector('div.re-error > p', :content => "The Error Message to Show")
    end      
    
  end
end

describe "re_alert" do 
  include RSpec::Rails::HelperExampleGroup
  
  def call_re_alert(error, success, notice)
    flash[:error] = "#{error}"
    flash[:success] = "#{success}"
    flash[:notice] = "#{notice}"
    helper.re_alert
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_alert")
  end
  
  it "should be html safe" do
    call_re_alert("error", "", "").should  be_html_safe
    call_re_alert("<error>", "", "").should have_selector('div#re_alert > div.error > span') do |error_message|
      error_message.inner_html.should == "&lt;error&gt;"
    end
  end      
  
  describe "setting an error message" do
    it "should display the message" do
      call_re_alert("error", "", "").should have_selector('div#re_alert > div.error > strong', :content => 'Error :')
      call_re_alert("error", "", "").should have_selector('div#re_alert > div.error > span', :content => "error")
    end

    it "should not display the success message or notice message" do
      call_re_alert("error", "success", "notice").should_not have_selector('div.success')
      call_re_alert("error", "success", "notice").should_not have_selector('div.notice')
    end
    
    it "should reset the error, success and notice message" do
      call_re_alert("error", "success", "notice")
      flash[:error].should be_blank
      flash[:success].should be_blank
      flash[:notice].should be_blank
    end
  end

  describe "setting a success message" do
    it "should display the message" do
      call_re_alert("", "success", "").should have_selector('div#re_alert > div.success > strong', :content => "Success :")
      call_re_alert("", "success", "").should have_selector('div#re_alert > div.success > span', :content => "success")
    end

    it "should not display the notice message" do
      call_re_alert("", "success", "notice").should_not have_selector('div.notice')
    end

    it "should reset the success and notice message" do
      call_re_alert("", "success", "notice")
      flash[:error].should be_blank
      flash[:success].should be_blank
      flash[:notice].should be_blank
    end
  end

  describe "setting a notice message" do
    it "should display the message" do
      call_re_alert("", "", "notice").should have_selector('div#re_alert > div.notice > strong', :content => "Warning :")
      call_re_alert("", "", "notice").should have_selector('div#re_alert > div.notice > span', :content => "notice")
    end

    it "should reset the notice message" do
      call_re_alert("", "", "notice")
      flash[:notice].should be_blank
    end
  end

  describe "setting nothing" do
    it "should have an empty re_alert block" do
      call_re_alert("", "", "").should have_selector('div#re_alert', :content => "")
    end
  end
  
end


describe "re_alert_js" do 
  include RSpec::Rails::HelperExampleGroup
  def call_re_alert_js(error, success, notice)
    flash[:error] = "#{error}"
    flash[:success] = "#{success}"
    flash[:notice] = "#{notice}"
    helper.re_alert_js
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_alert_js")
  end
  
  it "should be a safe buffer" do
    call_re_alert_js("error", "", "").should be_html_safe
    call_re_alert_js("<error>", "", "").should  =~ /&lt;error&gt;/
  end      
  
  describe "setting an error message" do
    it "should display the message" do
      call_re_alert_js("<p>error</p>", "", "").should =~ /\$.re_error_message/
    end

    it "should not display the success message or notice message" do
      call_re_alert_js("error", "success", "notice").should_not =~ /\$.re_success_message/
      call_re_alert_js("error", "success", "notice").should_not =~ /\$.re_notice_message/
    end
  
    it "should reset the error, success and notice message" do
      call_re_alert_js("error", "success", "notice")
      flash[:error].should be_blank
      flash[:success].should be_blank
      flash[:notice].should be_blank
    end
  end
  
  describe "setting a success message" do
    it "should display the message" do
      call_re_alert_js("", "success", "").should =~ /\$.re_success_message/
    end
  
    it "should not display the notice message" do
      call_re_alert_js("", "success", "notice").should_not =~ /\$.re_notice_message/
    end
  
    it "should reset the success and notice message" do
      call_re_alert_js("", "success", "notice")
      flash[:error].should be_blank
      flash[:success].should be_blank
      flash[:notice].should be_blank
    end
  end
  
  describe "setting a notice message" do
    it "should display the message" do
      call_re_alert_js("", "", "notice").should =~ /\$.re_notice_message/
    end
  
    it "should reset the notice message" do
      call_re_alert_js("", "", "notice")
      flash[:notice].should be_blank
    end
  end
end  
