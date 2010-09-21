require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "re_whitebox" do 
  include RSpec::Rails::HelperExampleGroup
  
  def call_re_whitebox
    helper.re_whitebox do
      "body text"
    end  
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_whitebox")
  end
  
  it "should wrap the content in a whitebox" do
    call_re_whitebox().should have_selector('div.re-whitebox div.re-whitebox-content', :content => "body text")
    call_re_whitebox().should have_selector('div.re-whitebox div.clear')
  end
end


describe "re_shadowbox" do 
  include RSpec::Rails::HelperExampleGroup
  
  def call_re_shadowbox
    helper.re_shadowbox do
      'body text'
    end
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_shadowbox")
  end
  
  it "should wrap the content in a shadowbox" do
    call_re_shadowbox.should have_selector('div.re-shadowbox-outer div.re-shadowbox-inner', :content => "body text")
    call_re_shadowbox.should have_selector('div.re-shadowbox-outer div.clear')
  end
end

