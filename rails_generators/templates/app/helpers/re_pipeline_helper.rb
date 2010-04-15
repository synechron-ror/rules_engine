module RePipelineHelper

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
