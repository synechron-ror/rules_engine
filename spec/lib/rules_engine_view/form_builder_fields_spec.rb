require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe RulesEngineView::FormBuilder do 
  include Webrat::Matchers
  
  before do 
    @expected_attrib = :the_attrib
    
    @mock_object = mock('the-object')
    @mock_template = mock("the-template")
    
    @mock_template.stub!(:label).and_return("<label/>".html_safe)
    
    @builder = RulesEngineView::FormBuilder.new('builder-name', @mock_object, @mock_template, {}, nil)
  end
  
  %w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|
    describe "#{method}" do 
      before(:each) do
        @mock_template.stub!(method).and_return("<#{method}/>".html_safe)
      end
      
      it "should call the origional method" do 
        @mock_template.should_receive(method)
        @builder.send(method, @expected_attrib)
      end

      it "should build the form by calling re_build_form_label, re_build_form_data, and re_build_form_field" do    
        @builder.should_receive(:re_build_form_label).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_label')
        @builder.should_receive(:re_build_form_data).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_data')
        @builder.should_receive(:re_build_form_field).with('re_build_form_label' + 're_build_form_data', hash_including(:dummy => 'option'))
        @builder.send(method, @expected_attrib, :dummy => 'option')
      end
      
      it "should build the form field" do
        @builder.send(method, @expected_attrib).should have_selector("div.re-form-field") do |form_field|
          form_field.should have_selector("div.re-form-label") do |form_label|
            form_label.should have_selector("label")
          end
          form_field.should have_selector("div.re-form-data") do |form_data|
            form_data.should have_selector("#{method}")
          end
        end
      end          

      it "should use the span options in the call" do
        @builder.send(method, @expected_attrib, {}).should have_selector("div.re-form-field.span-12") do |form_field|
          form_field.should have_selector("div.re-form-label.span-4")
          form_field.should have_selector("div.re-form-data.span-8.last")
        end
        
        @builder.send(method, @expected_attrib, {:span => '5x5'}).should have_selector("div.re-form-field.span-10") do |form_field|
          form_field.should have_selector("div.re-form-label.span-5")
          form_field.should have_selector("div.re-form-data.span-5.last")
        end
      end          
        
      it "should use the span options in the builder" do
        @builder = RulesEngineView::FormBuilder.new('builder-name', @mock_object, @mock_template, {:span => '5x5'}, nil)
        @builder.send(method, @expected_attrib, {}).should have_selector("div.re-form-field.span-10") do |form_field|
          form_field.should have_selector("div.re-form-label.span-5")
          form_field.should have_selector("div.re-form-data.span-5.last")
        end
      end          
        
      it "should use the override the builder span options with the field options" do
        @builder = RulesEngineView::FormBuilder.new('builder-name', @mock_object, @mock_template, {:span => '5x5'}, nil)
        @builder.send(method, @expected_attrib, {:span => '3x3'}).should have_selector("div.re-form-field.span-6") do |form_field|
          form_field.should have_selector("div.re-form-label.span-3")
          form_field.should have_selector("div.re-form-data.span-3.last")
        end
      end          
      
      %w(error hint label required span).each do |option|
        it "should exclude the #{option} from the calls to label and method" do    
          @builder.should_receive("label").with(anything(), anything, {}).and_return("test")
          @builder.should_receive("orig_" + method).with(anything(), {}).and_return("<#{method}/>")
          @builder.send(method, @expected_attrib, option.to_sym => 'test')
        end
      end      
    end    
  end

  describe "check_box" do 
    before(:each) do
      @mock_template.stub!(:check_box).and_return("<check_box/>".html_safe)
    end
    
    it "should call the origional method" do 
      @mock_template.should_receive(:check_box)
      @builder.send(:check_box, @expected_attrib)
    end
   
    it "should build the form by calling re_build_form_label, re_build_form_data, and re_build_form_field" do    
      @builder.should_receive(:re_build_form_label).with("&nbsp;", hash_including(:dummy => 'option')).and_return('&nbsp;')
      @builder.should_receive(:re_build_form_label).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_label')
      @builder.should_receive(:re_build_form_data).with(anything(), hash_including(:dummy => 'option')).and_return('re_build_form_data')
      @builder.should_receive(:re_build_form_field).with('&nbsp;' + 're_build_form_data', hash_including(:dummy => 'option'))
      @builder.send(:check_box, @expected_attrib, :dummy => 'option')
    end
  
    it "should not pass the required flag to the first label" do    
      @builder.should_not_receive(:re_build_form_label).with("&nbsp;", hash_including(:required => true))
      @builder.should_receive(:re_build_form_label).with("&nbsp;", anything()).and_return('&nbsp;')
      @builder.should_receive(:re_build_form_label).with(anything(), hash_including(:required => true)).and_return('re_build_form_label')
      @builder.should_receive(:re_build_form_data).with(anything(), hash_including(:required => true)).and_return('re_build_form_data')
      @builder.should_receive(:re_build_form_field).with('&nbsp;' + 're_build_form_data', hash_including(:required => true))
      @builder.send(:check_box, @expected_attrib, :required => true)
    end
    
    it "should build the form field" do
      checkbox = @builder.send(:check_box, @expected_attrib)
      checkbox.should have_selector("div.re-form-field > div.re-form-label") do |form_label|
        form_label.inner_html.should == "&nbsp;"
      end
      
      checkbox.should have_selector("div.re-form-field") do |form_field|
        form_field.should have_selector("div.re-form-data.re-form-field-checkbox") do |form_data|
          form_data.should have_selector("check_box")
          form_data.should have_selector("check_box + span.form-text") do |form_text|
            form_text.should have_selector(".re-form-label label")
          end
        end
      end
    end          
    
    it "should build the form field the default dimensions 4x8" do    
      @builder.send(:check_box, @expected_attrib).should have_selector("div.re-form-field.span-12.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-4")
        form_field.should have_selector("div.re-form-data.span-8.last")
      end
    end
  
    it "should build the form field the span-dimensions :span=>LABELxDATA" do    
      @builder.send(:check_box, @expected_attrib, :span=>'8x12').should have_selector("div.re-form-field.span-20.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-8")
        form_field.should have_selector("div.re-form-data.span-12.last")
      end
    end
  
    it "should build the form field the span-dimensions :span=>LABEL" do    
      @builder.send(:check_box, @expected_attrib, :span=>'6').should have_selector("div.re-form-field.span-8.clear") do |form_field|
        form_field.should have_selector("div.re-form-label.span-6")
        form_field.should have_selector("div.re-form-data.span-2.last")
      end
    end
  
    it "should set the required field in the form data" do    
      @builder.send(:check_box, @expected_attrib, :required=>true).should have_selector("div.re-form-field") do |form_field|
        form_field.should have_selector("div.re-form-data span.re-form-required", :content => "*")
      end
    end
  
    %w(error hint label required span).each do |option|
      it "should exclude the #{option} from the calls to label and method" do    
        @builder.should_receive("label").with(anything(), anything, {}).and_return("test")
        @builder.should_receive("orig_check_box").with(anything(), {}, anything(), anything()).and_return("<check_box/>")
        @builder.send(:check_box, @expected_attrib, option.to_sym => 'test')
      end
    end    
  end
  
  describe "re_error_on" do 
    describe "no error" do
      it "should be blank" do
        @mock_object.stub!(:errors).and_return({})
        @builder.send(:re_error_on, "Error Message to Write").should be_blank
      end      
    end
  
    describe "has errors error" do
      it "should call re_error_on_tag" do
        @mock_object.stub!(:errors).and_return({:opps => "there is an error"})
        @builder.should_receive(:re_error_on_tag).with("Error Message to Write")
        @builder.send(:re_error_on, "Error Message to Write")
      end  
        
      it "should display the error" do
        @mock_object.stub!(:errors).and_return({:opps => "there is an error"})
        @builder.send(:re_error_on, "Error Message to Write").should =~ /Error Message to Write/
      end      
    end
  end     
end