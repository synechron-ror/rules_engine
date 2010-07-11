class ReWorkflow < ActiveRecord::Base

  has_many :re_plan_workflows, :dependent => :destroy
  has_many :re_plans, :through => :re_plan_workflows, :order => 're_plan_workflows.position'
  
  has_many :re_rules, :foreign_key => :re_workflow_id, :dependent => :destroy, :order => :position
  
  ACTIVATED_STATUS_DRAFT  = 0
  ACTIVATED_STATUS_ACTIVE = 1
  
  CHANGED_STATUS_DRAFT      = 0
  CHANGED_STATUS_CHANGED    = 1
  CHANGED_STATUS_CURRENT    = 2
  
  validates_presence_of   :code
  validates_presence_of   :title
  validates_uniqueness_of :code, :case_sensitive => false, :message=>"alread taken."
  
  named_scope :order_code,  :order => 're_workflows.code ASC'
  named_scope :order_title, :order => 're_workflows.title ASC'

  def code=(new_code)
    self[:code] = new_code.strip.downcase.gsub(/[^a-zA-Z0-9]+/i, '_') if new_code && new_record?
  end
  
  def copy! re_workflow
    activated_attrs = re_workflow.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      self[key] = value
    end
    
    self.re_rules = re_workflow.re_rules.plan { |rule| ReRule.new.copy!(rule) }

    self
  end

  def equals? re_workflow
    activated_attrs = re_workflow.attributes
    ignore_attributes.each{|key| activated_attrs.delete(key)}

    activated_attrs.each do |key, value|
      return false unless self[key] == value
    end
    
    return false if (self.re_rules.length != re_workflow.re_rules.length)    
    self.re_rules.each_with_index do |re_rule, index|
      return false unless re_rule.equals?(re_workflow.re_rules[index])
    end
    
    true
  end
  
  def workflow_error
    return 'rules required' if re_rules.empty?
    return 'error within rules' if re_rules.any? { | re_rule | re_rule.rule_error }    
    nil
  end
  
  def has_plan? re_plan
    self.re_plans.include? re_plan
  end
  
  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "type", "parent_re_workflow_id", "activated_status", "changed_status", "created_at", "updated_at"]
    end
end
