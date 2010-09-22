module RulesEngineView
  module Alerts
    
    def re_error_on(model, message)
      result = ''.html_safe
      unless model.errors.empty?
        result << '<div class="re-error"><p>'.html_safe
        result << message
        result << '</p></div>'.html_safe
      end
      result
    end  

    def re_alert
      result = '<div id="re_alert">'.html_safe
      
      unless flash[:error].blank?
        result << '<div class="error"><strong>Error : </strong><span>'.html_safe
        result << flash.delete(:error)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'.html_safe

        flash.delete(:success)
        flash.delete(:notice)
      end

      unless flash[:success].blank?
        result << '<div class="success"><strong>Success : </strong><span>'.html_safe
        result << flash.delete(:success)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'.html_safe

        flash.delete(:notice)
      end      

      unless flash[:notice].blank?
        result << '<div class="notice"><strong>Warning : </strong><span>'.html_safe
        result << flash.delete(:notice)
        result << '</span><a class="re-alert-close" href="#">Close</a></div>'.html_safe
      end      
      result << '</div>'.html_safe
      
      return result
    end    
    
    def re_alert_js
      unless flash[:error].blank?  
        flash.delete(:success)
        flash.delete(:notice)
        return "$.re_error_message('".html_safe + escape_javascript(flash.delete(:error)) + "');".html_safe
      end
      unless flash[:success].blank?
        flash.delete(:notice)
        return "$.re_success_message('".html_safe + escape_javascript(flash.delete(:success)) + "');".html_safe
      end      
      unless flash[:notice].blank?
        return "$.re_notice_message('".html_safe + escape_javascript(flash.delete(:notice)) + "');".html_safe
      end    
    end  

    
  end
end
