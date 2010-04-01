class RePipeline < RePipelineBase

  has_one :activated_re_pipeline, :class_name => "RePipelineActivated", 
                          :foreign_key => :parent_re_pipeline_id, :dependent => :destroy

  has_many :re_job_audits
  
  # before_save :reset_activated_status, :reset_changed_status

  def activate!
    self.activated_re_pipeline ||= RePipelineActivated.new
    activated_re_pipeline.copy! self
    
    self.class.transaction do
      activated_re_pipeline.save! unless self.new_record?
      save
    end
  end

  def deactivate!
   self.activated_re_pipeline.destroy unless activated_re_pipeline.nil?          
   self.activated_re_pipeline = nil
   self.activated_status = RePipelineBase::ACTIVATED_STATUS_DRAFT
   save
  end  

  def revert! 
    return if activated_re_pipeline.nil?    
    self.copy!(activated_re_pipeline)        
    save
  end  

  def activated_status
    if self.activated_re_pipeline.nil?
      RePipelineBase::ACTIVATED_STATUS_DRAFT
    else 
      RePipelineBase::ACTIVATED_STATUS_ACTIVE
    end  
  end

  def changed_status
    if self.activated_re_pipeline.nil?
      RePipelineBase::CHANGED_STATUS_DRAFT
    elsif !equals?(self.activated_re_pipeline) 
      RePipelineBase::CHANGED_STATUS_CHANGED
    else
      RePipelineBase::CHANGED_STATUS_CURRENT
    end
  end    
    
  # private
  #   def reset_activated_status
  #     if self.activated_re_pipeline.nil?
  #       self.activated_status = RePipelineBase::ACTIVATED_STATUS_DRAFT
  #     else 
  #       self.activated_status = RePipelineBase::ACTIVATED_STATUS_ACTIVE
  #     end  
  #   end
  # 
  #   def reset_changed_status
  #     if self.activated_re_pipeline.nil?
  #       self.changed_status = RePipelineBase::CHANGED_STATUS_DRAFT
  #     elsif !equals?(self.activated_re_pipeline) 
  #       self.changed_status = RePipelineBase::CHANGED_STATUS_CHANGED
  #     else
  #       self.changed_status = RePipelineBase::CHANGED_STATUS_CURRENT
  #     end
  #   end    
end
