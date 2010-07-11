module RulesEngineHelper

  def re_plan_status re_plan
    case re_plan.status
    when RePlan::PLAN_STATUS_DRAFT
      'draft'
    when RePlan::PLAN_STATUS_CHANGED
      'changed'
    else #  RePlan::PLAN_STATUS_PUBLISHED
      'published'
    end
  end    
  
  def re_workflow_list
    @re_workflows ||= ReWorkflow.order_title.find(:all)
  end
end
