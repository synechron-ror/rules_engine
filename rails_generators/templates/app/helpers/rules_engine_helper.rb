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
  
  def re_workflow_list
    @re_workflows ||= ReWorkflow.order_title.find(:all)
  end
  
  def re_plan_version re_plan
    return '' if re_plan.nil? || re_plan.plan_version.nil?
    "Ver.#{re_plan.plan_version}"    
  end
end
