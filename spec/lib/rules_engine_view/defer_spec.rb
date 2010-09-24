require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "set_re_javascript_include" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_javascript_include")
  end
  
  it "should set defer_re_javascript_include" do
    helper.should_receive(:content_for).with(:defer_re_javascript_include)
    helper.set_re_javascript_include('me')
  end

  it "should set defer_re_javascript_include variable " do
    helper.set_re_javascript_include('me')
    helper.instance_variable_get(:@_content_for)[:defer_re_javascript_include].should == helper.javascript_include_tag('me')
  end
end

describe "set_re_breadcrumbs" do 
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    RulesEngineView::Config.prefix_breadcrumbs = nil
  end

  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_breadcrumbs")
  end
  
  it "should set defer_re_breadcrumbs" do
    helper.should_receive(:content_for).with(:defer_re_breadcrumbs)
    helper.set_re_breadcrumbs('me')
  end

  it "should set defer_re_breadcrumbs variable " do
    helper.set_re_breadcrumbs('me')
    helper.instance_variable_get(:@_content_for)[:defer_re_breadcrumbs].should == helper.re_breadcrumbs('me')
  end
end

describe "set_re_breadcrumbs_prefix" do 
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    RulesEngineView::Config.prefix_breadcrumbs = "HERE"
  end
  
  it "should add the prefix to the breadcrumb array" do    
    helper.set_re_breadcrumbs('me')
    helper.instance_variable_get(:@_content_for)[:defer_re_breadcrumbs].should == helper.re_breadcrumbs('HERE', 'me')
  end
end

describe "set_re_breadcrumbs_right" do 
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    RulesEngineView::Config.prefix_breadcrumbs = nil
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("set_re_breadcrumbs_right")
  end
  
  it "should set defer_re_breadcrumbs" do
    helper.should_receive(:content_for).with(:defer_re_breadcrumbs)
    helper.set_re_breadcrumbs_right('me')
  end

  it "should set defer_re_breadcrumbs variable " do
    helper.set_re_breadcrumbs_right('me')
    helper.instance_variable_get(:@_content_for)[:defer_re_breadcrumbs].should == helper.re_breadcrumbs_right('me')
  end  
end
  
describe "set_re_breadcrumbs_right_prefix" do 
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    RulesEngineView::Config.prefix_breadcrumbs = "HERE"
  end
  
  it "should add the prefix to the breadcrumb array" do
    helper.set_re_breadcrumbs_right('me')
    helper.instance_variable_get(:@_content_for)[:defer_re_breadcrumbs].should == helper.re_breadcrumbs_right('HERE', 'me')
  end
end

