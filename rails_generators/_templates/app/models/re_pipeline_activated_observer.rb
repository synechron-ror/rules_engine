class RePipelineActivatedObserver < ActiveRecord::Observer

  def after_update(record)        
    RePipelineActivated.reset_cache(record.code)
  end

  def after_create(record)    
    RePipelineActivated.reset_cache(record.code)
  end
  
end