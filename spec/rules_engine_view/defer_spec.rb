require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "set_re_javascript_include", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_javascript_include")
  end
  
  it "should set defer_re_javascript_include" do
    @template.should_receive(:content_for).with(:defer_re_javascript_include)
    eval_erb("<% set_re_javascript_include('me') %>")
  end

  it "should set defer_re_javascript_include variable " do
    eval_erb("<% set_re_javascript_include('me') %>")
    @template.instance_variable_get("@content_for_defer_re_javascript_include").should == eval_erb("<%= javascript_include_tag('me') %>")
  end
end

describe "set_re_breadcrumbs", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_breadcrumbs")
  end
  
  it "should set defer_re_breadcrumbs" do
    @template.should_receive(:content_for).with(:defer_re_breadcrumbs)
    eval_erb("<% set_re_breadcrumbs('me') %>")
  end

  it "should set defer_re_breadcrumbs variable " do
    eval_erb("<% set_re_breadcrumbs('me') %>")
    @template.instance_variable_get("@content_for_defer_re_breadcrumbs").should == eval_erb("<%= re_breadcrumbs('me') %>")
  end
end


describe "set_re_breadcrumbs_right", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_breadcrumbs_right")
  end
  
  it "should set defer_re_breadcrumbs" do
    @template.should_receive(:content_for).with(:defer_re_breadcrumbs)
    eval_erb("<% set_re_breadcrumbs_right('me') %>")
  end

  it "should set defer_re_breadcrumbs variable " do
    eval_erb("<% set_re_breadcrumbs_right('me') %>")
    @template.instance_variable_get("@content_for_defer_re_breadcrumbs").should == eval_erb("<%= re_breadcrumbs_right('me') %>")
  end
end


describe "set_re_subnav", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_subnav")
  end
  
  it "should set defer_re_subnav" do
    @template.should_receive(:content_for).with(:defer_re_subnav)
    eval_erb("<% set_re_subnav('me', 'link') %>")
  end

  it "should set defer_re_subnav variable " do
    eval_erb("<% set_re_subnav('me', 'link') %>")
    @template.instance_variable_get("@content_for_defer_re_subnav").should == eval_erb("<%= re_subnav('me', 'link') %>")
  end
end
