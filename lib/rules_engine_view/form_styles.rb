module RulesEngineView
  module FormStyles
    
    def re_build_form_field(value, options = {})
      result = ''
      result << "<div class='re-form-field"
      result << " re-form-disabled" if options.include?(:disabled) && options[:disabled]
      result << " #{options[:class]}" if options.include?(:class)
      result << " span-#{options[:span] || '12'}"
      result << " clear'"
      result << " id='form_field_#{options[:id]}'" unless options[:id].blank?
      result << ">"          
      result << "#{value}"
      result << "</div>"
      result      
    end
    
    def re_build_form_label value, options = {}
      result = "<div class='re-form-label"
      result << "-error" if options.include?(:error) && !options[:error].blank?
      result << " re-form-disabled" if options.include?(:disabled) && options[:disabled]
      result << " #{options[:class]}" if options.include?(:class)
      result << " span-#{options[:span] || '4'}"
      result << "'"
      result << " id='re_form_label_#{options[:id]}'" unless options[:id].blank?
      result << ">"
      result << "#{value}"
      if options.include?(:required) && options[:required]
        result << "<span class='re-form-required"
        result << " re-form-disabled" if options.include?(:disabled) && options[:disabled]
        result << "'>*</span>"
      end  
      result << "</div>"
      result
    end
    
    def re_build_form_data value, options = {}
      result = "<div class='re-form-data"
      result << "-error" if options.include?(:error) && !options[:error].blank?
      result << " re-form-disabled" if options.include?(:disabled) && options[:disabled]
      result << " #{options[:class]}" if options.include?(:class)
      result << " span-#{options[:span] || '8'}"
      result << " last"
      result << "'" 
      result << " id='form_data_#{options[:id]}'" if options.include?(:id)
      result << ">"
      result << "#{value}"
      if options.include?(:text) && !options[:text].blank?
        result << "<span class='form-text'>"
        result << options[:text]
        result << "</span>"
      end
      if options.include?(:hint) && !options[:hint].blank? && (!options.include?(:error) || options[:error].blank?)
        result << "<span class='form-hint'>"
        result << options[:hint]
        result << "</span>"
      end
      if options.include?(:error) && !options[:error].blank?
        result << "<span class='form-error-message'>"
        result << options[:error]
        result << "</span>"
      end
      result << "</div>"
      result      
    end
    
    def re_options_exclude(options)
      options.except(:error, :hint, :label, :text, :required, :span)
    end
    
    def re_label_span(options)      
      span = options[:span]
      if span =~ %r{^\d+x\d+$}
        return span.split("x")[0].to_i 
      elsif span =~ %r{^\d+$}
        return span.to_i 
      end
      
      return 4
    end
    
    def re_data_span(options)
      span = options[:span]
      if span =~ %r{^\d+x\d+$}
        return span.split("x")[1].to_i 
      elsif span =~ %r{^\d+$} 
        if span.to_i < 8
          return 8 - span.to_i 
        elsif span.to_i < 16
          return 16 - span.to_i 
        else  
          return 24 - span.to_i 
        end  
      end
      
      return 8
    end    

    def re_field_span(options)
      re_label_span(options) + re_data_span(options)
    end    
  end
end

