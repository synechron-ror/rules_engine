module RulesEngineView
  module Alerts
    
    def re_alert
      unless flash[:error].blank?
        result = '<div class="error"><strong>Error : </strong><span>'
        result << flash.delete(:error)
        result << '</span></div>'

        flash.delete(:success)
        flash.delete(:notice)
        return result      
      end

      unless flash[:success].blank?
        result = '<div class="success"><strong>Success : </strong><span>'
        result << flash.delete(:success)
        result << '</span></div>'

        flash.delete(:notice)
        return result      
      end      

      unless flash[:notice].blank?
        result = ''
        result = '<div class="notice"><strong>Warning : </strong><span>'
        result << flash.delete(:notice)
        result << '</span></div>'
        return result      
      end      
    end    
    
    def re_alert_js
      unless flash[:error].blank?  
        flash.delete(:success)
        flash.delete(:notice)
        return "$.re_error_message('" + escape_javascript(flash.delete(:error)) + "');"
      end
      unless flash[:success].blank?
        flash.delete(:notice)
        return "$.re_success_message('" + escape_javascript(flash.delete(:success)) + "');"
      end      
      unless flash[:notice].blank?
        return "$.re_notice_message('" + escape_javascript(flash.delete(:notice)) + "');"
      end    
    end  

    
  end
end

ActionView::Base.class_eval do
  include RulesEngineView::Alerts
end