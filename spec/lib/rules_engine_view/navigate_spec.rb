require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "re_breadcrumbs" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_breadcrumbs")
  end

  it "should be html safe" do
    helper.re_breadcrumbs("default value").should be_html_safe
    helper.re_breadcrumbs("<default value>").should =~/&lt;default value&gt;/
  end      

  it "should set the default class to re-breadcrumbs" do
    helper.re_breadcrumbs("default value").should have_selector("div.re-breadcrumbs")
  end

  it "should show the links seperated by a <span>" do
    helper.re_breadcrumbs("<div id=one>one</div>".html_safe, "<div id=two>two</div>".html_safe, "<div id=last>last</div>".html_safe).should have_selector("div.re-breadcrumbs") do |breadcrumbs|
      breadcrumbs.should have_selector("div#one", :content => "one") 
      breadcrumbs.should have_selector("div#one + span.re-breadcrumbs-seperator", :content => ">")
      breadcrumbs.should have_selector("div#one + span + div#two + span + em > div#last")
      breadcrumbs.should have_selector("div#one + span + div#two", :content => "two")
      breadcrumbs.should have_selector("div#one + span + div#two + span.re-breadcrumbs-seperator", :content => ">")
      breadcrumbs.should have_selector("div#one + span + div#two + span + em", :content => "last")
    end
  end
end

describe "re_breadcrumbs_right" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_breadcrumbs_right")
  end

  it "should be html safe" do
    helper.re_breadcrumbs_right("default value").should be_html_safe
    helper.re_breadcrumbs_right("<default value>").should =~/&lt;default value&gt;/
  end      

  it "should set the default class to re-breadcrumbs" do
    helper.re_breadcrumbs_right("default value").should have_selector("div.re-breadcrumbs") do |breadcrumbs|
      breadcrumbs.should have_selector("div.re-breadcrumb-right", :content => "default value")
    end
  end

  it "should show the links seperated by a <span>" do
    helper.re_breadcrumbs_right("<div id=one>one</div>".html_safe, "<div id=two>two</div>".html_safe, "<div id=last>last</div>".html_safe, "<div id=right>right</div>".html_safe).should have_selector("div.re-breadcrumbs") do |breadcrumbs|
      breadcrumbs.should have_selector("div#one", :content => "one") 
      breadcrumbs.should have_selector("div#one + span", :content => ">")
      breadcrumbs.should have_selector("div#one + span + div#two + span + em > div#last")
      breadcrumbs.should have_selector("div#one + span + div#two", :content => "two")
      breadcrumbs.should have_selector("div#one + span + div#two + span", :content => ">")
      breadcrumbs.should have_selector("div#one + span + div#two + span + em", :content => "last")
      breadcrumbs.should have_selector("div#one + span + div#two + span + em + div.re-breadcrumb-right > div#right", :content => "right")
    end
  end
end

