require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "re_button_submit", :type => :helper do 
  def call_re_button_submit(title, color, options = {})
    eval_erb("<%= re_button_submit(\"#{title}\", \"#{color}\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_button_submit")
  end

  it "should set the default class to re-form-field" do
    call_re_button_submit("Title", "red").should have_tag('div.re-form-button input[type=submit].re-form-button-red')
  end
  
  it "should set the width from the span value" do
    call_re_button_submit("Title", "red", :span => '20').should have_tag('div.re-form-button.span-20')
  end  
end

%w(gray blue green orange red).each do |color|
  describe "re_button_submit_#{color}", :type => :helper do 
    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_button_submit_#{color}")
    end
    
    it "should call button submit" do
      @template.should_receive(:re_button_submit).with("title", "#{color}", {})
      eval_erb("<% re_button_submit_#{color}('title') %>")
    end
  end
end


describe "re_button_link", :type => :helper do 
  def call_re_button_link(title, url, color, options = {})
    eval_erb("<%= re_button_link(\"#{title}\", \"#{url}\", \"#{color}\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_button_link")
  end

  it "should set the default class to re-form-field" do
    call_re_button_link("Title", "http://wow", "red").should have_tag("div.re-form-button a[href=http://wow].re-form-button-red")
  end
  
  it "should set the width from the span value" do
    call_re_button_link("Title", "http://wow", "red", :span => '20').should have_tag('div.re-form-button.span-20')
  end  
  
end

%w(gray blue green orange red).each do |color|
  describe "re_button_link_#{color}", :type => :helper do 
    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_button_link_#{color}")
    end
    
    it "should call button link" do
      @template.should_receive(:re_button_link).with("title", "url", "#{color}", {})
      eval_erb("<%= re_button_link_#{color}('title', 'url') %>")
    end
  end
end


describe "re_add_link", :type => :helper do 
  it "should call link_to with the title" do
    @template.should_receive(:link_to).with("mock_title", "#", anything())
    eval_erb("<%= re_add_link('mock_title', 'mock_id') %>")    
  end      

  it "should call link_to with the id" do
    @template.should_receive(:link_to).with(anything(), anything(), hash_including({:id => 'mock_id'}))
    eval_erb("<%= re_add_link('mock_title', 'mock_id') %>")    
  end      

  it "should set the link class to re-add-link" do
    @template.should_receive(:link_to).with(anything(), anything(), hash_including({:class => 're-add-link'}))
    eval_erb("<%= re_add_link('mock_title', 'mock_id') %>")    
  end      

end

describe "re_remove_link", :type => :helper do 
  it "shouldbe blank if the id is 0" do
    eval_erb("<%= re_remove_link('mock_title', 'object[name]', 0) %>").should be_blank
  end      

  it "should call link_to with the title" do
    @template.should_receive(:link_to).with("mock_title", anything(), anything())
    eval_erb("<%= re_remove_link('mock_title', 'object[name]', 'mock_id') %>")    
  end      

  it "should call link_to with the id" do
    @template.should_receive(:link_to).with(anything(), anything(), hash_including({:id => 'object_name_remove'}))
    eval_erb("<%= re_remove_link('mock_title', 'object[name]', 'mock_id') %>")    
  end      

  it "should set the link class to re-remove-link" do
    @template.should_receive(:link_to).with(anything(), anything(), hash_including({:class => 're-remove-link'}))
    eval_erb("<%= re_remove_link('mock_title', 'object[name]', 'mock_id') %>")    
  end      

end

describe "re_remove_field", :type => :helper do 
  it "should be blank if the id is 0" do
    eval_erb("<%= re_remove_field('object[name]', 0) %>").should be_blank
  end      

  it "should call hidden_field_tag with the _delete field" do
    @template.should_receive(:hidden_field_tag).with("object[name][_delete]", anything(), anything())
    eval_erb("<%= re_remove_field('object[name]', 'mock_id') %>")    
  end      

  it "should call hidden_field_tag with the id" do
    @template.should_receive(:hidden_field_tag).with(anything(), anything(), hash_including({:id => 'object_name__delete'}))
    eval_erb("<%= re_remove_field('object[name]', 'mock_id') %>")    
  end      
end


describe "re_button_add", :type => :helper do 
  it "should  a link to with the class re-button-add" do
    eval_erb("<%= re_button_add('http://test') %>").should have_tag('a.re-button-add[href=http://test]')
  end      
end

describe "re_button_remove", :type => :helper do 
  it "should  a link to with the class re-button-remove" do
    eval_erb("<%= re_button_remove('http://test') %>").should have_tag('a.re-button-remove[href=http://test]')
  end      
end

describe "re_button_select", :type => :helper do 
  it "should  a link to with the class re-button-select" do
    eval_erb("<%= re_button_select('http://test') %>").should have_tag('a.re-button-select[href=http://test]')
  end      
end

describe "re_button_checked", :type => :helper do 
  it "should  a link to with the class re-button-checked" do
    eval_erb("<%= re_button_checked('http://test') %>").should have_tag('a.re-button-checked[href=http://test]')
  end      
end


describe "re_button_unchecked", :type => :helper do 
  it "should  a link to with the class re-button-unchecked" do
    eval_erb("<%= re_button_unchecked('http://test') %>").should have_tag('a.re-button-unchecked[href=http://test]')
  end      
end
