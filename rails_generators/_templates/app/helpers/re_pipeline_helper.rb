module RePipelineHelper

  def javascript_alert_messages
    unless flash[:error].blank?  
      flash.delete(:success)
      flash.delete(:notice)
      return "$.error_message('" + escape_javascript(flash.delete(:error)) + "');"
    end
    unless flash[:success].blank?
      flash.delete(:notice)
      return "$.success_message('" + escape_javascript(flash.delete(:success)) + "');"
    end      
    unless flash[:notice].blank?
      return "$.notice_message('" + escape_javascript(flash.delete(:notice)) + "');"
    end    
  end  

  def re_pipeline_status re_pipeline
    case re_pipeline.changed_status
    when RePipelineBase::CHANGED_STATUS_DRAFT
      'draft'
    when RePipelineBase::CHANGED_STATUS_CHANGED
      'changed'
    else #  RePipelineBase::CHANGED_STATUS_CURRENT
      'current'
    end
  end    

end
