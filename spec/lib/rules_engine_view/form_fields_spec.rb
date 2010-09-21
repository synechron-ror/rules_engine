require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

%w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|

  describe "re_#{method}" do 
    
    include RSpec::Rails::HelperExampleGroup
    
    before(:each) do
      helper.stub!(method + "_tag").and_return("<#{method}/>")
    end
    
    def call_method method, options = {}
      helper.send("re_#{method}", "Label Value", "the_name", "The Value", options)
    end
    
    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_#{method}")
    end

    it "should build the form by calling re_build_form_label, re_build_form_data, and re_build_form_field" do    
      helper.should_receive(:re_build_form_label).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_label')
      helper.should_receive(:re_build_form_data).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_data')
      helper.should_receive(:re_build_form_field).with('re_build_form_label' + 're_build_form_data', hash_including(:dummy => 'option'))
      call_method(method, :dummy => 'option')
    end
    
    it "should build the form field with a re-form-label and a re-form-data" do    
      call_method(method).should have_selector("div.re-form-field") do |form_field|
        form_field.should have_selector("div.re-form-label") do |form_label|
          form_label.should have_selector("label[for=the_name]", :content => "Label Value")
        end
        form_field.should have_selector("div.re-form-data") do |form_data|
          form_data.should have_selector(method)
        end
      end
    end

    it "should build the form field the default dimensions 4x8" do    
      call_method(method).should have_selector("div.re-form-field.span-12.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-4")
        form_field.should have_selector("div.re-form-data.span-8.last")
      end
    end
    
    it "should build the form field the span-dimensions :span=>LABELxDATA" do    
      call_method(method, :span=>'8x12').should have_selector("div.re-form-field.span-20.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-8")
        form_field.should have_selector("div.re-form-data.span-12.last")
      end
    end

    it "should build the form field the span-dimensions :span=>LABEL" do    
      call_method(method, :span=>'6').should have_selector("div.re-form-field.span-8.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-6")
        form_field.should have_selector("div.re-form-data.span-2.last")
      end
    end

    %w(error hint label required span).each do |option|
      it "should exclude the #{option} from the calls to label and method" do    
        helper.should_receive("label_tag").with(anything(), anything, {}).and_return("test")
        helper.should_receive(method + "_tag").with(anything(), anything, {}).and_return("<#{method}/>")
        call_method(method, option.to_sym => 'test')
      end
    end
  end
end

describe "re_check_box" do 
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    helper.stub!("check_box_tag").and_return("<check_box/>")
  end
  
  def call_re_check_box options = {}
    helper.re_check_box("Label", "the_name", "1", "false", options)
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_check_box")
  end
  
  it "should build the form by calling re_build_form_label, re_build_form_data, and re_build_form_field" do    
    helper.should_receive(:re_build_form_label).with("&nbsp;", hash_including(:dummy => 'option')).and_return('&nbsp;')
    helper.should_receive(:re_build_form_label).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_label')
    helper.should_receive(:re_build_form_data).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_data')
    helper.should_receive(:re_build_form_field).with('&nbsp;' + 're_build_form_data', hash_including(:dummy => 'option'))
    call_re_check_box(:dummy => 'option')
  end
  
  it "should not pass the required flag to the first label" do    
    helper.should_not_receive(:re_build_form_label).with("&nbsp;", hash_including(:required => true))
    helper.should_receive(:re_build_form_label).with("&nbsp;", anything()).and_return('&nbsp;')
    helper.should_receive(:re_build_form_label).with(anything(), hash_including(:required => true)).and_return('re_build_form_label')
    helper.should_receive(:re_build_form_data).with(anything(), hash_including(:required => true)).and_return('re_build_form_data')
    helper.should_receive(:re_build_form_field).with('&nbsp;' + 're_build_form_data', hash_including(:required => true))
    call_re_check_box(:required => true)
  end
    
  it "should build the form field with a label and form data" do
    checkbox = call_re_check_box
    checkbox.should have_selector("div.re-form-field > div.re-form-label") do |form_label|
      form_label.inner_html.should == "&nbsp;"
    end
    
    checkbox.should have_selector("div.re-form-field") do |form_field|
      form_field.should have_selector("div.re-form-data.re-form-field-checkbox") do |form_data|
        form_data.should have_selector("check_box")
        form_data.should have_selector("check_box + span.form-text") do |form_text|
          form_text.should have_selector(".re-form-label label[for=the_name]", :content => "Label")
        end
      end
    end
  end
  
  it "should build the form field the default dimensions 4x8" do    
    call_re_check_box.should have_selector("div.re-form-field.span-12.clear") do |form_field|
      form_field.should have_selector("div.re-form-label.span-4")
      form_field.should have_selector("div.re-form-data.span-8.last")
    end
  end
  
  it "should build the form field the span-dimensions :span=>LABELxDATA" do    
    call_re_check_box(:span=>'8x12').should have_selector("div.re-form-field.span-20.clear") do |form_field|
      form_field.should have_selector("div.re-form-label.span-8")
      form_field.should have_selector("div.re-form-data.span-12.last")
    end
  end

  it "should build the form field the span-dimensions :span=>LABEL" do    
    call_re_check_box(:span=>'6').should have_selector("div.re-form-field.span-8.clear") do |form_field|
      form_field.should have_selector("div.re-form-label.span-6")
      form_field.should have_selector("div.re-form-data.span-2.last")
    end
  end

  it "should set the required field in the form data" do    
    call_re_check_box(:required=>true).should have_selector("div.re-form-field") do |form_field|
      form_field.should have_selector("div.re-form-data span.re-form-required", :content => "*")
    end
  end

  %w(error hint label required span).each do |option|
    it "should exclude the #{option} from the calls to label and method" do    
      helper.should_receive("label_tag").with(anything(), anything, {}).and_return("test")
      helper.should_receive("check_box_tag").with(anything(), anything, anything, {}).and_return("<check_box/>")
      call_re_check_box(option.to_sym => 'test')
    end
  end
end
  

describe "re_form_text" do 
  include RSpec::Rails::HelperExampleGroup
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_form_text")
  end
  
  it "should build the form field with a label and form text" do    
    helper.re_form_text("Label", "Text", {}).should have_selector("div.re-form-field") do |form_field|
      form_field.should have_selector("div.re-form-label", :content => "Label")
      form_field.should have_selector("div.re-form-data span.form-text", :content => "Text")
    end
  end
end

describe "re_form_blank" do 
  include RSpec::Rails::HelperExampleGroup
    
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_form_blank")
  end
  
  it "should build the form field with a label and data sections" do
    helper.re_form_blank({}).should have_selector("div.re-form-field") do |form_field|
      form_field.should have_selector("div.re-form-label") do |form_label|
        form_label.inner_html.should == "&nbsp;"
      end  
      form_field.should have_selector("div.re-form-data") do |form_data|
        form_data.inner_html.should == "&nbsp;"
      end  
    end
  end
end
