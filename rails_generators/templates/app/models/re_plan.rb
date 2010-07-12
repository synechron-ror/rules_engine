class RePlan < ActiveRecord::Base    
  has_many :re_plan_workflows, :dependent => :destroy
  has_many :re_workflows, :through => :re_plan_workflows, :order => 're_plan_workflows.position'
  
  PLAN_STATUS_DRAFT      = 0
  PLAN_STATUS_CHANGED    = 1
  PLAN_STATUS_PUBLISHED  = 2
  
  validates_presence_of   :code
  validates_presence_of   :title
  validates_uniqueness_of :code, :case_sensitive => false, :message=>"alread taken."
  
  named_scope :order_code,  :order => 'code ASC'
  named_scope :order_title, :order => 'title ASC'
  
  before_create :before_create_plan
  before_save :before_save_plan

  def before_create_plan
    self.status = PLAN_STATUS_DRAFT
  end  

  def before_save_plan
    self.changed!(false) if changes.detect { |change| !ignore_attributes.include?(change[0])}    
  end  

  def code=(new_code)
    self[:code] = new_code.strip.downcase.gsub(/[^a-zA-Z0-9]+/i, '_') if new_code && new_record?
  end
  
  def default_workflow= re_workflow
    re_plan_workflow = re_plan_workflows.detect { | re_plan_workflow | re_plan_workflow.re_workflow_id == re_workflow.id}
    re_plan_workflow.move_to_top if re_plan_workflow
  end
  
  def default_workflow
    self.re_workflows.empty? ? nil : self.re_workflows[0]
  end
  
  def plan_error
    return 'workflows required' if re_workflows.empty?
    return 'error within workflows' if re_workflows.any? { | re_workflow | re_workflow.workflow_error }    
    nil
  end

  def published!
    self.status = PLAN_STATUS_PUBLISHED
    self.save!
  end

  def changed!(update = true)
    if self.status == PLAN_STATUS_PUBLISHED
      self.status = PLAN_STATUS_CHANGED
      self.save! if update
    end  
  end
  
  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "status", "created_at", "updated_at"]
    end
end
