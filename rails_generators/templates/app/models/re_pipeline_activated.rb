class RePipelineActivated < RePipelineBase
  belongs_to :re_pipeline, :foreign_key => :parent_re_pipeline_id
  
  def self.find_by_code(code)
    return find_by_code_without_caching(code) unless RulesEngine::Cache.perform_caching?

    code.gsub!(/[^a-zA-Z0-9]+/i, '_')
    re_pipeline = RulesEngine::Cache.cache_store.read("activated_pipeline_#{code}")
    if (re_pipeline.nil?)
      re_pipeline = find_by_code_without_caching(code)

      RulesEngine::Cache.cache_store.write("activated_pipeline_#{code}", re_pipeline)
    end    

    re_pipeline
  end

  def self.find_by_code_without_caching(code)
    RePipelineActivated.find(:first, :conditions => ["code = ?", code], :include => :re_rules)
  end

  def self.reset_cache(code)
    return unless RulesEngine::Cache.perform_caching?

    code.gsub!(/[^a-zA-Z0-9]+/i, '_')
    RulesEngine::Cache.cache_store.delete("activated_pipeline_#{code}")
  end

end
