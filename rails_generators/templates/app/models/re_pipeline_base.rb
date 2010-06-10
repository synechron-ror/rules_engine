class RePipelineBase < ActiveRecord::Base
  set_table_name :re_pipelines  
  
  has_many :re_rules, :foreign_key => :re_pipeline_id, :dependent => :destroy, :order => :position
  
  ACTIVATED_STATUS_DRAFT  = 0
  ACTIVATED_STATUS_ACTIVE = 1
  
  CHANGED_STATUS_DRAFT      = 0
  CHANGED_STATUS_CHANGED    = 1
  CHANGED_STATUS_CURRENT    = 2
  
  validates_presence_of   :code
  validates_presence_of   :title
  validates_uniqueness_of :code, :scope => :parent_re_pipeline_id, :case_sensitive => false, :message=>"alread taken."
  
  named_scope :order_code,  :order => 're_pipelines.code ASC'
  named_scope :order_title, :order => 're_pipelines.title ASC'

  def code=(new_code)
    self[:code] = new_code.downcase.gsub(/[^a-zA-Z0-9]+/i, '_') if new_code && new_record?
  end
  
  def copy! re_pipeline
    activated_attrs = re_pipeline.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      self[key] = value
    end
    
    self.re_rules = re_pipeline.re_rules.map { |rule| ReRule.new.copy!(rule) }

    self
  end

  def equals? re_pipeline
    activated_attrs = re_pipeline.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      return false unless self[key] == value
    end
    
    return false if (self.re_rules.length != re_pipeline.re_rules.length)    
    self.re_rules.each_with_index do |re_rule, index|
      return false unless re_rule.equals?(re_pipeline.re_rules[index])
    end
    
    true
  end
  
  def pipeline_error
    return 'rules required' if re_rules.empty?
    
    re_rules.each do |re_rule|
      error = re_rule.rule_error
      return error unless error.blank?
    end
    
    nil
  end

  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "type", "parent_re_pipeline_id", "activated_status", "changed_status", "created_at", "updated_at"]
    end
end
