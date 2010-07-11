module RulesEngineView
  class FormBuilder < ActionView::Helpers::FormBuilder
    
    include RulesEngineView::FormStyles
    
    %w(text_field password_field file_field text_area select date_select datetime_select time_select time_zone_select).each do |method|
      src = <<-END_SRC
        alias_method :orig_#{method}, :#{method}
        
        def #{method}(method, *args)
          options = args.extract_options!           
          
          error = @template.error_message_on(object || object_name, method)
          options.reverse_merge!(:error => error) unless error.blank?
          options.reverse_merge!(:span => @options[:span]) unless @options.nil? || @options[:span].blank?
          
          field_label = options[:label] || method.to_s.titleize
          form_label = re_build_form_label(label(method, field_label, re_options_exclude(options)), options.merge(:span => re_label_span(options)))
          form_data = re_build_form_data(orig_#{method}(method, *(args << re_options_exclude(options))), options.merge(:span => re_data_span(options))) 
          re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
        end
      END_SRC
      module_eval src, __FILE__, __LINE__
    end  
    
    src = <<-END_SRC
      alias_method :orig_check_box, :check_box
      
      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
  
        error = @template.error_message_on(object || object_name, method)
        options.reverse_merge!(:error => error) unless error.blank?
        options.reverse_merge!(:span => @options[:span]) unless @options.nil? || @options[:span].blank?
        
        field_label = options[:label] || method.to_s.titleize        
        form_label = re_build_form_label('&nbsp;', options.except(:required).merge(:span => re_label_span(options)))
        form_data_label = re_build_form_label(label(method, field_label, re_options_exclude(options)), re_options_exclude(options).merge(:required => options[:required]))        
        form_data = re_build_form_data(orig_check_box(method, re_options_exclude(options), checked_value, unchecked_value),  options.merge(:text => form_data_label, :class=>'re-form-field-checkbox', :span => re_data_span(options))) 
        re_build_form_field(form_label + form_data, options.merge(:span => re_field_span(options)))
      end
    END_SRC
    module_eval src, __FILE__, __LINE__
  end  
  
  module FormBuilderView
    [:form_for, :fields_for, :form_remote_for, :remote_form_for].each do |method|
      src = <<-END_SRC
        def re_#{method}(record_or_name_or_array, *args, &proc)
          options = args.extract_options!
          options[:builder] = RulesEngineView::FormBuilder
    
          #{method}(record_or_name_or_array, *(args << options), &proc)
        end
      END_SRC
      module_eval src, __FILE__, __LINE__
    end  
  end      
end


ActionView::Base.class_eval do
  include RulesEngineView::FormBuilderView
end