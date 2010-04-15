module RulesEngineView
  module Buttons

    def re_button_submit(title, color, options ={})
      klass = "form-button-#{color} #{options[:class]}"
      result = "<div class='form-button"
      result << " span-#{options[:span]}" unless options[:span].blank?
      result << "'>"
      result << submit_tag(title, options.merge(:class=> klass).except(:span))      
      result << "</div>"
      result
    end

    def re_button_submit_gray(title, options = {})
      return re_button_submit(title, "gray", options)
    end

    def re_button_submit_blue(title, options = {})
      return re_button_submit(title, "blue", options)
    end

    def re_button_submit_green(title, options = {})
      return re_button_submit(title, "green", options)
    end

    def re_button_submit_orange(title, options = {})
      return re_button_submit(title, "orange", options)
    end

    def re_button_submit_red(title, options = {})
      return re_button_submit(title, "red", options)
    end


    def re_button_link(title, url, color, options = {})
      klass = "form-button-#{color} #{options[:class]}"
      result = "<div class='form-button"
      result << " span-#{options[:span]}" unless options[:span].blank?
      result << "'>"
      result << link_to("<span>#{title}</span>", url, options.merge(:class=> klass).except(:span))      
      result << "</div>"
      result
    end
    
    def re_button_link_gray(title, url, options = {})
      return re_button_link(title, url, "gray", options)
    end

    def re_button_link_blue(title, url, options = {})
      return re_button_link(title, url, "blue", options)
    end

    def re_button_link_green(title, url, options = {})
      return re_button_link(title, url, "green", options)
    end

    def re_button_link_orange(title, url, options = {})
      return re_button_link(title, url, "orange", options)
    end

    def re_button_link_red(title, url, options = {})
      return re_button_link(title, url, "red", options)
    end

    
    ############################## 
    # nested buttons
    def render_add_link(title, id) 
      link_to("#{title}", "#", :class => 'nested-add-link', :id => "#{id}")
    end  

    def render_remove_link(title, object_name, id)
      return "" if id == 0
      
      builder_id = object_name.gsub('[', '_').gsub(']', '')    
      link_to("#{title}", "#", :class => 'nested-remove-link', :id => "#{builder_id}_remove")
    end

    def render_delete_field(object_name, id)
      return "" if id == 0
      
      builder_id = object_name.gsub('[', '_').gsub(']', '')
      hidden_field_tag("#{object_name}[_delete]", "", :id => "#{builder_id}__delete")
    end
    
  end      
end

ActionView::Base.class_eval do
  include RulesEngineView::Buttons
end