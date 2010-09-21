require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "re_button_submit" do 
  include RSpec::Rails::HelperExampleGroup
  
  def call_re_button_submit(title, color, options = {})
    helper.re_button_submit(title, color, options)
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_button_submit")
  end

  it "should set the default class to re-form-field" do
    call_re_button_submit("Title", "red").should have_selector('div.re-form-button input[type=submit].re-form-button-red')
  end
  
  it "should set the width from the span value" do
    call_re_button_submit("Title", "red", :span => '20').should have_selector('div.re-form-button.span-20')
  end  

  it "should be html safe" do
    call_re_button_submit("Title", "red").should have_selector('div.re-form-button input[value=Title]')
  end  
  
end

%w(gray blue green orange red).each do |color|
  describe "re_button_submit_#{color}" do 
    include RSpec::Rails::HelperExampleGroup
    
    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_button_submit_#{color}")
    end
    
    it "should call button submit" do
      helper.should_receive(:re_button_submit).with("title", "#{color}", {})
      helper.instance_eval("re_button_submit_#{color}('title')")
    end
  end
end

describe "re_button_link" do 
  include RSpec::Rails::HelperExampleGroup
  
  def call_re_button_link(title, url, color, options = {})
    helper.re_button_link(title, url, color, options)
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_button_link")
  end

  it "should set the default class to re-form-field" do
    call_re_button_link("Title", "http://wow", "red").should have_selector("div.re-form-button a.re-form-button-red") do |anchor|
      anchor.first.attribute('href').value.should == "http://wow"
    end    
  end
  
  it "should set the width from the span value" do
    call_re_button_link("Title", "http://wow", "red", :span => '20').should have_selector('div.re-form-button.span-20')
  end  
  
end

%w(gray blue green orange red).each do |color|
  describe "re_button_link_#{color}" do 
    include RSpec::Rails::HelperExampleGroup

    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_button_link_#{color}")
    end
    
    it "should call button link" do
      helper.should_receive(:re_button_link).with("title", "url", "#{color}", {})
      helper.instance_eval("re_button_link_#{color}('title', 'url')")
    end
  end
end


describe "re_add_link" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should call link_to with the title" do
    helper.should_receive(:link_to).with("mock_title", "#", anything())
    helper.re_add_link('mock_title', 'mock_id')
  end      

  it "should call link_to with the id" do
    helper.should_receive(:link_to).with(anything(), anything(), hash_including({:id => 'mock_id'}))
    helper.re_add_link('mock_title', 'mock_id')
  end      

  it "should set the link class to re-add-link" do
    helper.should_receive(:link_to).with(anything(), anything(), hash_including({:class => 're-add-link'}))
    helper.re_add_link('mock_title', 'mock_id')
  end      
end

describe "re_remove_link" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "shouldbe blank if the id is 0" do
    helper.re_remove_link('mock_title', 'object[name]', 0).should be_blank
  end      

  it "should call link_to with the title" do
    helper.should_receive(:link_to).with("mock_title", anything(), anything())
    helper.re_remove_link('mock_title', 'object[name]', 'mock_id')
  end      

  it "should call link_to with the id" do
    helper.should_receive(:link_to).with(anything(), anything(), hash_including({:id => 'object_name_remove'}))
    helper.re_remove_link('mock_title', 'object[name]', 'mock_id')
  end      

  it "should set the link class to re-remove-link" do
    helper.should_receive(:link_to).with(anything(), anything(), hash_including({:class => 're-remove-link'}))
    helper.re_remove_link('mock_title', 'object[name]', 'mock_id')
  end      

end

describe "re_remove_field" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should be blank if the id is 0" do
    helper.re_remove_field('object[name]', 0).should be_blank
  end      

  it "should call hidden_field_tag with the _delete field" do
    helper.should_receive(:hidden_field_tag).with("object[name][_delete]", anything(), anything())
    helper.re_remove_field('object[name]', 'mock_id')
  end      

  it "should call hidden_field_tag with the id" do
    helper.should_receive(:hidden_field_tag).with(anything(), anything(), hash_including({:id => 'object_name__delete'}))
    helper.re_remove_field('object[name]', 'mock_id')
  end      
end

describe "re_button_add" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should  a link to with the class re-button-add" do
    helper.re_button_add('http://test').should have_selector('a.re-button-add') do |anchor|
      anchor.first.attribute('href').value.should == "http://test"
    end
  end      
end

describe "re_button_remove" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should  a link to with the class re-button-remove" do
    helper.re_button_remove('http://test').should have_selector('a.re-button-remove') do |anchor|
      anchor.first.attribute('href').value.should == "http://test"
    end
  end      
end

describe "re_button_select" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should  a link to with the class re-button-select" do
    helper.re_button_select('http://test').should have_selector('a.re-button-select') do |anchor|
      anchor.first.attribute('href').value.should == "http://test"
    end
  end      
end

describe "re_button_checked" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should  a link to with the class re-button-checked" do
    helper.re_button_checked('http://test').should have_selector('a.re-button-checked') do |anchor|
      anchor.first.attribute('href').value.should == "http://test"
    end
  end      
end

