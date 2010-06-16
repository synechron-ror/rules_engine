require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "re_breadcrumbs", :type => :helper do 
  def call_re_breadcrumbs(*links)
    eval_erb("<%= re_breadcrumbs(*#{links.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_breadcrumbs")
  end

  it "should set the default class to re-breadcrumbs" do
    call_re_breadcrumbs("default value").should have_tag("div.re-breadcrumbs")
  end

  it "should show the links seperated by a <span>" do
    call_re_breadcrumbs("<div id=one>one</div>", "<div id=two>two</div>", "<div id=last>last</div>").should have_tag("div.re-breadcrumbs") do |inner_text|
      with_tag("div#one", :text => "one") 
      with_tag("div#one + span.re-breadcrumbs-seperator", :text => ">")
      with_tag("div#one + span + div#two + span + em > div#last")
      with_tag("div#one + span + div#two", :text => "two")
      with_tag("div#one + span + div#two + span.re-breadcrumbs-seperator", :text => ">")
      with_tag("div#one + span + div#two + span + em", :text => "last")
    end
  end
end

describe "re_breadcrumbs_right", :type => :helper do 
  def call_re_breadcrumbs_right(*links)
    eval_erb("<%= re_breadcrumbs_right(*#{links.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_breadcrumbs_right")
  end

  it "should set the default class to re-breadcrumbs" do
    call_re_breadcrumbs_right("default value").should have_tag("div.re-breadcrumbs") do
      with_tag("div.re-breadcrumb-right", :text => "default value")
    end
  end

  it "should show the links seperated by a <span>" do
    call_re_breadcrumbs_right("<div id=one>one</div>", "<div id=two>two</div>", "<div id=last>last</div>", "<div id=right>right</div>").should have_tag("div.re-breadcrumbs") do |inner_text|
      with_tag("div#one", :text => "one") 
      with_tag("div#one + span", :text => ">")
      with_tag("div#one + span + div#two + span + em > div#last")
      with_tag("div#one + span + div#two", :text => "two")
      with_tag("div#one + span + div#two + span", :text => ">")
      with_tag("div#one + span + div#two + span + em", :text => "last")
      with_tag("div#one + span + div#two + span + em + div.re-breadcrumb-right > div#right", :text => "right")
    end
  end
end

