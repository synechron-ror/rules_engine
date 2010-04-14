require File.expand_path(File.dirname(__FILE__) ) + "/../spec_helper"

describe "re_build_form_field", :type => :helper do 
  def call_re_build_form_field(value, options = {})
    eval_erb("<%= re_build_form_field(\"#{value}\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_build_form_field")
  end

  it "should set the default class to re-form-field" do
    call_re_build_form_field("default value").should have_tag("div.re-form-field", :text => "default value")
  end

  it "should be disabled if set" do
    call_re_build_form_field("default value", :disabled => true).should have_tag("div.re-form-field.re-form-disabled")
    call_re_build_form_field("default value", :disabled => false).should_not have_tag("div.re-form-field.re-form-disabled")
  end

  it "should add the class if set" do
    call_re_build_form_field("default value", :class => "test-class").should have_tag("div.re-form-field.test-class")
  end

  it "should set the default span to 12" do
    call_re_build_form_field("default value").should have_tag("div.re-form-field.span-12")
  end

  it "should use the value of the span option" do
    call_re_build_form_field("default value", :span => '22').should have_tag("div.re-form-field.span-22")
  end

  it "should use the clear class to ensure each field is at the start of the section" do
    call_re_build_form_field("default value").should have_tag("div.re-form-field.clear")
  end

  it "should set the id for the field to form_field_[id]" do
    call_re_build_form_field("default value", :id => "NEW").should have_tag("div.re-form-field#form_field_NEW")
  end
    
end

describe "re_build_form_label", :type => :helper do 
  def call_re_build_form_label(label, options = {})
    eval_erb("<%= re_build_form_label(\"#{label}\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_build_form_label")
  end

  it "should set the default class to re-form-label" do
    call_re_build_form_label("default value").should have_tag("div.re-form-label", :text => "default value")
  end

  it "should set the default class to re-form-label-error if there is an error set" do
    call_re_build_form_label("default value", :error => "ouch").should have_tag("div.re-form-label-error")
  end

  it "should be disabled if set" do
    call_re_build_form_label("default value", :disabled => true).should have_tag("div.re-form-label.re-form-disabled")
    call_re_build_form_label("default value", :disabled => false).should_not have_tag("div.re-form-label.re-form-disabled")
  end

  it "should add the class if set" do
    call_re_build_form_label("default value", :class => "test-class").should have_tag("div.re-form-label.test-class")
  end

  it "should set the default span to 4" do
    call_re_build_form_label("default value").should have_tag("div.re-form-label.span-4")
  end

  it "should use the value of the span option" do
    call_re_build_form_label("default value", :span => '22').should have_tag("div.re-form-label.span-22")
  end

  it "should set the id for the field to re_form_label_[id]" do
    call_re_build_form_label("default value", :id => "NEW").should have_tag("div#re_form_label_NEW")
  end
  
  it "should include a span.re-form-required > * when required set" do
    call_re_build_form_label("default value", :required => "true").should have_tag("div") do
      with_tag("span.re-form-required", :text => "*")
    end
  end

  it "should include a span.re-form-required.re-form-disabled > * when required set" do
    call_re_build_form_label("default value", :required => "true", :disabled => "true").should have_tag("div") do
      with_tag("span.re-form-required.re-form-disabled", :text => "*")
    end
  end        
end 

describe "re_build_form_data", :type => :helper do 
  def call_re_build_form_data(label, options = {})
    eval_erb("<%= re_build_form_data(\"#{label}\", #{options.inspect})%>")
  end
  
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_build_form_data")
  end

  it "should set the default class to re-form-data" do
    call_re_build_form_data("default value").should have_tag("div.re-form-data", :text => "default value")
  end

  it "should set the default class to re-form-data-error if there is an error set" do
    call_re_build_form_data("default value", :error => "ouch").should have_tag("div.re-form-data-error")
  end
  
  it "should be disabled if set" do
    call_re_build_form_data("default value", :disabled => true).should have_tag("div.re-form-data.re-form-disabled")
    call_re_build_form_data("default value", :disabled => false).should_not have_tag("div.re-form-data.re-form-disabled")
  end
  
  it "should add the class if set" do
    call_re_build_form_data("default value", :class => "test-class").should have_tag("div.re-form-data.test-class")
  end
  
  it "should set the default span to 8" do
    call_re_build_form_data("default value").should have_tag("div.re-form-data.span-8")
  end

  it "should use the value of the span option" do
    call_re_build_form_data("default value", :span => '22').should have_tag("div.re-form-data.span-22")
  end

  it "should use the last class to ensure it is the last field in a section" do
    call_re_build_form_data("default value").should have_tag("div.re-form-data.last")
  end
  
  it "should set the id for the field to form_value_[id]" do
    call_re_build_form_data("default value", :id => "NEW").should have_tag("div.re-form-data#form_data_NEW")
  end
  
  it "should add a form-hint span if :hint set" do
    call_re_build_form_data("default value", :error => "", :hint => "hint value").should have_tag("div.re-form-data > span.form-hint", :text => "hint value")
  end
  
  it "should not add a form-hint span if :hint set but there is an error" do
    call_re_build_form_data("default value", :error => "ouch", :hint => "hint value").should_not have_tag("span.form-hint")
  end

  it "should not add a form-hint span if :hint is blank" do
    call_re_build_form_data("default value", :hint => "").should_not have_tag("span.form-hint")
  end

  it "should add a form-txt span if :text set" do
    call_re_build_form_data("default value", :text => "text value").should have_tag("div.re-form-data > span.form-text", :text => "text value")
  end

  it "should not add a form-txt span if :text is blank" do
    call_re_build_form_data("default value", :text => "").should_not have_tag("div.re-form-data > span.form-text")
  end
  
  it "should not add a form-txt span if :text is blank" do
    call_re_build_form_data("default value", :text => "").should_not have_tag("span.form-text")
  end
  
  it "should add a form-error-message span if :error set" do
    call_re_build_form_data("default value", :error => "error value").should have_tag("div.re-form-data-error > span.form-error-message", :text => "error value")
  end
end

describe "re_options_exclude", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_options_exclude")
  end

  [:error, :hint, :label, :text, :required, :span].each do |option|
    it "should remove the option #{option}" do
      options = {:a =>"a", :b =>"b", :c =>"c", option => "option"}
      eval_erb("<%= re_options_exclude(#{options.inspect}).inspect%>").should == {:a =>"a", :b =>"b", :c =>"c"}.inspect
    end
  end
end

describe "re_label_span", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_label_span")
  end

  it "should be set to 4 by default" do
    eval_erb("<%= re_label_span({})%>").should == "4"
    eval_erb("<%= re_label_span(:span => 'X')%>").should == "4"
  end

  it "should use the first value of a NxN span" do
    eval_erb("<%= re_label_span(:span => '2x10')%>").should == "2"
    eval_erb("<%= re_label_span(:span => '20x10')%>").should == "20"
  end

  it "should use the value of a N span" do
    eval_erb("<%= re_label_span(:span => '2')%>").should == "2"
    eval_erb("<%= re_label_span(:span => '20')%>").should == "20"
  end
  
end

describe "re_data_span", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_data_span")
  end

  it "should be set to 8 by default" do
    eval_erb("<%= re_data_span({})%>").should == "8"
    eval_erb("<%= re_data_span(:span => 'X')%>").should == "8"
  end

  it "should use the second value of a NxN span" do
    eval_erb("<%= re_data_span(:span => '2x10')%>").should == "10"
    eval_erb("<%= re_data_span(:span => '2x20')%>").should == "20"
  end

  it "should be 8, 16, 24 minus the value of a N span" do
    eval_erb("<%= re_data_span(:span => '0')%>").should == "8"
    eval_erb("<%= re_data_span(:span => '1')%>").should == "7"
    eval_erb("<%= re_data_span(:span => '7')%>").should == "1"
    eval_erb("<%= re_data_span(:span => '8')%>").should == "8"
    eval_erb("<%= re_data_span(:span => '9')%>").should == "7"
    eval_erb("<%= re_data_span(:span => '15')%>").should == "1"
    eval_erb("<%= re_data_span(:span => '16')%>").should == "8"
    eval_erb("<%= re_data_span(:span => '17')%>").should == "7"
  end
  
end

describe "re_field_span", :type => :helper do 
  it "should be accessible to rails apps by default" do 
    ActionView::Base.new.methods.should include("re_field_span")
  end

  it "should be set to 12 by default" do
    eval_erb("<%= re_field_span({})%>").should == "12"
  end

  it "should use the sum of a NxN span" do
    eval_erb("<%= re_field_span(:span => '2x7')%>").should == "9"
    eval_erb("<%= re_field_span(:span => '2x10')%>").should == "12"
    eval_erb("<%= re_field_span(:span => '2x20')%>").should == "22"
  end

  it "should be in columns of 8, 16 or 24 " do
    eval_erb("<%= re_field_span(:span => '0')%>").should == "8"
    eval_erb("<%= re_field_span(:span => '1')%>").should == "8"
    eval_erb("<%= re_field_span(:span => '7')%>").should == "8"
    eval_erb("<%= re_field_span(:span => '8')%>").should == "16"
    eval_erb("<%= re_field_span(:span => '9')%>").should == "16"
    eval_erb("<%= re_field_span(:span => '15')%>").should == "16"
    eval_erb("<%= re_field_span(:span => '16')%>").should == "24"
    eval_erb("<%= re_field_span(:span => '17')%>").should == "24"
  end
  
end