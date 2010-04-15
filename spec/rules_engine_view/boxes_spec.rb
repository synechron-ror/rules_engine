require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "re_whitebox", :type => :helper do 
  def call_re_whitebox
    eval_erb("<% re_whitebox do %>body text<% end %>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_whitebox")
  end
  
  it "should wrap the content in a whitebox" do
    call_re_whitebox().should have_tag('div.re-whitebox div.re-whitebox-content', :text => "body text")
    call_re_whitebox().should have_tag('div.re-whitebox div.clear')
  end
end


describe "re_shadowbox", :type => :helper do 
  def call_re_shadowbox
    eval_erb("<% re_shadowbox do %>body text<% end %>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_shadowbox")
  end
  
  it "should wrap the content in a shadowbox" do
    call_re_shadowbox.should have_tag('div.re-shadowbox-outer div.re-shadowbox-inner', :text => "body text")
    call_re_shadowbox.should have_tag('div.re-shadowbox-outer div.clear')
  end
end

