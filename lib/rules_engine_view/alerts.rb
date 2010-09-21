module RulesEngineView
  module Alerts
    
    def re_alert
      result = '<div id="re_alert">'
      
      unless flash[:error].blank?
        result << '<div class="error"><strong>Error : </strong><span>'
        result << flash.delete(:error)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'

        flash.delete(:success)
        flash.delete(:notice)
      end

      unless flash[:success].blank?
        result << '<div class="success"><strong>Success : </strong><span>'
        result << flash.delete(:success)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'

        flash.delete(:notice)
      end      

      unless flash[:notice].blank?
        result << '<div class="notice"><strong>Warning : </strong><span>'
        result << flash.delete(:notice)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'
      end      
      result << '</div>'      
      
      return result
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
