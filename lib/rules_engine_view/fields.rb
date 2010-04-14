module RulesEngineView
  module Fields
    
    %w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|
      src = <<-END_SRC
        def #{method}_ext(label, name, value, *args)
          options = args.extract_options!           
          
          form_label = re_build_form_label(label_tag(name, label, re_options_exclude(options)), options.merge(:span => re_label_span(options)))
          form_data = re_build_form_data(#{method}_tag(name, value, *(args << re_options_exclude(options))), options.merge(:span => re_data_span(options))) 
          re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
        end
      END_SRC
      module_eval src, __FILE__, __LINE__
    end
      
    def check_box_ext(label, name, value = "1", checked = false, options = {})        
      form_label = re_build_form_label('&nbsp;', options.except(:required).merge(:span => re_label_span(options)))
      form_data_label = re_build_form_label(label_tag(name, label, re_options_exclude(options)), re_options_exclude(options).merge(:required => options[:required]))
      form_data = re_build_form_data(check_box_tag(name, value, checked, re_options_exclude(options)), options.merge(:text => form_data_label, :class=>'re-form-field-checkbox', :span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end

    def form_text_ext(label, text = "", options = {})        
      form_label = re_build_form_label(label, options.merge(:span => re_label_span(options)))
      form_data = re_build_form_data("", options.merge(:text => text, :span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end
  
    def form_blank_ext(options = {})
      form_label = re_build_form_label("&nbsp;", options.merge(:span => re_label_span(options)))
      form_data = re_build_form_data("&nbsp;", options.merge(:span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end

  end      
end

ActionView::Base.class_eval do
  include RulesEngineView::Fields
end