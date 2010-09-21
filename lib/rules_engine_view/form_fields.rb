module RulesEngineView
  module FormFields
    
    %w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|
      src = <<-END_SRC
        def re_#{method}(label, name, value, *args)
          options = args.extract_options!           
          
          form_label = re_build_form_label(label_tag(name, label, re_options_exclude(options)), options.merge(:span => re_label_span(options)))
          form_data = re_build_form_data(#{method}_tag(name, value, *(args << re_options_exclude(options))), options.merge(:span => re_data_span(options))) 
          re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
        end
      END_SRC
      module_eval src, __FILE__, __LINE__
    end
      
    def re_check_box(label, name, value = "1", checked = false, options = {})        
      form_label = re_build_form_label('&nbsp;', options.except(:required).merge(:span => re_label_span(options)))
      form_data_label = re_build_form_label(label_tag(name, label, re_options_exclude(options)), re_options_exclude(options).merge(:required => options[:required]))
      form_data = re_build_form_data(check_box_tag(name, value, checked, re_options_exclude(options)), options.merge(:text => form_data_label, :class=>'re-form-field-checkbox', :span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end

    def re_form_text(label, text = "", options = {})        
      form_label = re_build_form_label(label, options.merge(:span => re_label_span(options)))
      form_data = re_build_form_data("", options.merge(:text => text, :span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end
  
    def re_form_blank(options = {})
      form_label = re_build_form_label("&nbsp;", options.merge(:span => re_label_span(options)))
      form_data = re_build_form_data("&nbsp;", options.merge(:span => re_data_span(options))) 
      re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
    end

  end      
end
