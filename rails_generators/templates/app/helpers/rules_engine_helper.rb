module RulesEngineHelper

  def re_plan_status re_plan
    case re_plan.plan_status
    when RePlan::PLAN_STATUS_PUBLISHED
      'published'
    when RePlan::PLAN_STATUS_CHANGED
      'changed'
    else # when RePlan::PLAN_STATUS_DRAFT
      'draft'
    end
  end    
  
  def re_plan_version re_plan
    return '' if re_plan.nil? || re_plan.plan_version.nil?
    "Ver.#{re_plan.plan_version}"    
  end
  
  def re_history_status process_status
    case process_status.to_i
    when RulesEngine::Process::PROCESS_STATUS_RUNNING
      'running'
    when RulesEngine::Process::PROCESS_STATUS_SUCCESS
      'success'
    when RulesEngine::Process::PROCESS_STATUS_FAILURE
      'error'      
    else # RulesEngine::Process::PROCESS_STATUS_NONE
      'info'
    end    
  end    

  def re_audit_status audit_status
    case audit_status.to_i
    when RulesEngine::Process::AUDIT_SUCCESS
      'success'
    when RulesEngine::Process::AUDIT_FAILURE
      'error'      
    else # RulesEngine::Process::AUDIT_INFO
      'info'
    end    
  end      
end
