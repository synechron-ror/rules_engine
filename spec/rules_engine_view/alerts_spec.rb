require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "re_alert", :type => :helper do 
  def call_re_alert(error, success, notice)
    src = <<-END_SRC
    <% 
      flash[:error] = "#{error}"
      flash[:success] = "#{success}"
      flash[:notice] = "#{notice}"
    %>    
    <%= re_alert %>
    END_SRC
    eval_erb(src)
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_alert")
  end
  
  describe "setting an error message" do
    it "should display the message" do
      call_re_alert("error", "", "").should have_tag('div.error > strong', :text => "Error :")
      call_re_alert("error", "", "").should have_tag('div.error > span', :text => "error")
    end

    it "should not display the success message or notice message" do
      call_re_alert("error", "success", "notice").should_not have_tag('div.success')
      call_re_alert("error", "success", "notice").should_not have_tag('div.notice')
    end

    it "should reset the error, success and notice message" do
      call_re_alert("error", "success", "notice")
      eval_erb("<%=flash[:error] %>").should == ""
      eval_erb("<%=flash[:success] %>").should == ""
      eval_erb("<%=flash[:notice] %>").should == ""
    end
  end

  describe "setting a success message" do
    it "should display the message" do
      call_re_alert("", "success", "").should have_tag('div.success > strong', :text => "Success :")
      call_re_alert("", "success", "").should have_tag('div.success > span', :text => "success")
    end

    it "should not display the notice message" do
      call_re_alert("", "success", "notice").should_not have_tag('div.notice')
    end

    it "should reset the success and notice message" do
      call_re_alert("", "success", "notice")
      eval_erb("<%=flash[:error] %>").should == ""
      eval_erb("<%=flash[:success] %>").should == ""
      eval_erb("<%=flash[:notice] %>").should == ""
    end
  end

  describe "setting a notice message" do
    it "should display the message" do
      call_re_alert("", "", "notice").should have_tag('div.notice > strong', :text => "Warning :")
      call_re_alert("", "", "notice").should have_tag('div.notice > span', :text => "notice")
    end

    it "should reset the notice message" do
      call_re_alert("", "", "notice")
      eval_erb("<%=flash[:notice] %>").should == ""
    end
  end
  
end


describe "re_alert_js", :type => :helper do 
  def call_re_alert_js(error, success, notice)
    src = <<-END_SRC
    <% 
      flash[:error] = "#{error}"
      flash[:success] = "#{success}"
      flash[:notice] = "#{notice}"
    %>    
    <%= re_alert_js %>
    END_SRC
    eval_erb(src)
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_alert_js")
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
      eval_erb("<%=flash[:error] %>").should == ""
      eval_erb("<%=flash[:success] %>").should == ""
      eval_erb("<%=flash[:notice] %>").should == ""
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
      eval_erb("<%=flash[:error] %>").should == ""
      eval_erb("<%=flash[:success] %>").should == ""
      eval_erb("<%=flash[:notice] %>").should == ""
    end
  end
  
  describe "setting a notice message" do
    it "should display the message" do
      call_re_alert_js("", "", "notice").should =~ /\$.re_notice_message/
    end
  
    it "should reset the notice message" do
      call_re_alert_js("", "", "notice")
      eval_erb("<%=flash[:notice] %>").should == ""
    end
  end
  
end

