require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

%w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|
          
  describe "re_#{method}", :type => :helper do 
    before(:each) do
      helper.stub!(method + "_tag").and_return("<#{method}/>")
    end
    
    def call_method method, options = {}
      eval_erb("<%=re_#{method}(\"Label Value\", \"the_name\", \"The Value\", #{options.inspect})%>")
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
      call_method(method).should have_tag("div.re-form-field") do
        with_tag("div.re-form-label") do
          with_tag("label[for=the_name]", :text => "Label Value")
        end
        with_tag("div.re-form-data") do
          with_tag(method)
        end
      end
    end

    it "should build the form field the default dimensions 4x8" do    
      call_method(method).should have_tag("div.re-form-field.span-12.clear") do
        with_tag("div.re-form-label.span-4")
        with_tag("div.re-form-data.span-8.last")
      end
    end
    
    it "should build the form field the span-dimensions :span=>LABELxDATA" do    
      call_method(method, :span=>'8x12').should have_tag("div.re-form-field.span-20.clear") do
        with_tag("div.re-form-label.span-8")
        with_tag("div.re-form-data.span-12.last")
      end
    end

    it "should build the form field the span-dimensions :span=>LABEL" do    
      call_method(method, :span=>'6').should have_tag("div.re-form-field.span-8.clear") do
        with_tag("div.re-form-label.span-6")
        with_tag("div.re-form-data.span-2.last")
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

describe "re_check_box", :type => :helper do 
  before(:each) do
    helper.stub!("check_box_tag").and_return("<check_box/>")
  end
  
  def call_re_check_box options = {}
    eval_erb("<%=re_check_box(\"Label\", \"the_name\", \"1\", \"false\", #{options.inspect})%>")
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
    call_re_check_box.should have_tag("div.re-form-field") do
      with_tag("div.re-form-label", :text => "&nbsp;")
      with_tag("div.re-form-data.re-form-field-checkbox") do
        with_tag("check_box")
        with_tag("check_box + span.form-text") do
          with_tag(".re-form-label label[for=the_name]", :text => "Label")
        end
      end
    end
  end
  
  it "should build the form field the default dimensions 4x8" do    
    call_re_check_box.should have_tag("div.re-form-field.span-12.clear") do
      with_tag("div.re-form-label.span-4")
      with_tag("div.re-form-data.span-8.last")
    end
  end
  
  it "should build the form field the span-dimensions :span=>LABELxDATA" do    
    call_re_check_box(:span=>'8x12').should have_tag("div.re-form-field.span-20.clear") do
      with_tag("div.re-form-label.span-8")
      with_tag("div.re-form-data.span-12.last")
    end
  end

  it "should build the form field the span-dimensions :span=>LABEL" do    
    call_re_check_box(:span=>'6').should have_tag("div.re-form-field.span-8.clear") do
      with_tag("div.re-form-label.span-6")
      with_tag("div.re-form-data.span-2.last")
    end
  end

  it "should set the required field in the form data" do    
    call_re_check_box(:required=>true).should have_tag("div.re-form-field") do
      with_tag("div.re-form-data span.re-form-required", :text => "*")
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
  

describe "re_form_text", :type => :helper do 
  def call_re_form_text options = {}
    eval_erb("<%=re_form_text(\"Label\", \"Text\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_form_text")
  end
  
  it "should build the form field with a label and form text" do
    
    call_re_form_text.should have_tag("div.re-form-field") do
      with_tag("div.re-form-label", :text => "Label")
      with_tag("div.re-form-data span.form-text", :text => "Text")
    end
  end
end

describe "re_form_blank", :type => :helper do 
  def call_re_form_blank options = {}
    eval_erb("<%=re_form_blank(#{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_form_blank")
  end
  
  it "should build the form field with a label and data sections" do
    call_re_form_blank.should have_tag("div.re-form-field") do
      with_tag("div.re-form-label", :text => "&nbsp;")
      with_tag("div.re-form-data", :text => "&nbsp;")
    end
  end
end
