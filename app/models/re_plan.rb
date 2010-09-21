class RePlan < ActiveRecord::Base    
  has_many :re_plan_workflows, :dependent => :destroy
  has_many :re_workflows, :through => :re_plan_workflows, :order => 're_plan_workflows.position'
  
  PLAN_STATUS_DRAFT      = 0
  PLAN_STATUS_CHANGED    = 1
  PLAN_STATUS_PUBLISHED  = 2
  PLAN_STATUS_REVERTED   = 3
  
  validates_presence_of   :code
  validates_presence_of   :title
  validates_uniqueness_of :code, :case_sensitive => false, :message=>"alread taken."
  
  named_scope :order_code,  :order => 'code ASC'
  named_scope :order_title, :order => 'title ASC'
  
  before_create :before_create_plan
  before_save :before_save_plan

  def before_create_plan
    self.plan_status = PLAN_STATUS_DRAFT
  end  

  def before_save_plan
    if (plan_status == PLAN_STATUS_REVERTED)
      self.plan_status = PLAN_STATUS_PUBLISHED
    elsif changes.detect { |change| !ignore_attributes.include?(change[0])}  
      self.changed!(false) 
    end  
  end  

  def code=(new_code)
    self[:code] = new_code.strip.downcase.gsub(/[^a-zA-Z0-9]+/i, '_') if new_code && new_record?
  end
  
  def publish
    data = { 
      "code" => code, 
      "title" => title, 
      "description" => description,
      "workflow" => re_workflows.empty? ? '' : re_workflows[0].code,
    }
    re_workflows.each_with_index do | re_workflow, index | 
      data["workflow_#{re_workflow.code}"] = re_workflow.publish 

      if re_workflows[-1] == re_workflow
        data["workflow_#{re_workflow.code}"]["next_workflow"] = ''
      else  
        data["workflow_#{re_workflow.code}"]["next_workflow"] = re_workflows[index+1].code
      end  
    end
    data
  end  

  def revert!(rule_data)
    self.plan_status = RePlan::PLAN_STATUS_REVERTED
    self.code = rule_data["code"]
    self.title = rule_data["title"]
    self.description = rule_data["description"]
    
    orig_re_workflows = []
    workflow_data = rule_data["workflow_#{rule_data["workflow"]}"]
    while (workflow_data && orig_re_workflows.length < 500)
      workflow_code = workflow_data["code"]
      re_workflow = ReWorkflow.find_by_code(workflow_code) || ReWorkflow.new
      re_workflow.revert!(workflow_data)
      orig_re_workflows << re_workflow
      
      next_workflow = workflow_data["next_workflow"]
      workflow_data = next_workflow.blank? ? nil : rule_data["workflow_#{next_workflow}"]
    end  
    
    self.re_workflows = orig_re_workflows
    self
  end  

  def add_workflow re_workflow
    return false if self.re_workflows.include?(re_workflow)
    self.re_workflows << re_workflow 
    changed!
    true
  end

  def remove_workflow re_workflow
    return false unless self.re_workflows.include?(re_workflow)
    self.re_workflows.delete(re_workflow)
    changed!
    true
  end  
  
  
  def default_workflow= re_workflow
    return if self.re_workflows.empty? || self.re_workflows[0] == re_workflow
    re_plan_workflow = re_plan_workflows.detect { | re_plan_workflow | re_plan_workflow.re_workflow_id == re_workflow.id}
    return unless re_plan_workflow

    re_plan_workflow.move_to_top
    
    self.re_plan_workflows(true)
    self.re_workflows(true)
    
    changed!
  end
  
  def default_workflow
    self.re_workflows.empty? ? nil : self.re_workflows[0]
  end
  
  def plan_error
    return 'workflows req\'d' if re_workflows.empty?
    return 'workflow error' if re_workflows.any? { | re_workflow | re_workflow.workflow_error }    
    nil
  end

  def published!
    self.plan_status = PLAN_STATUS_PUBLISHED
    self.save!
  end

  def changed!(update = true)
    if self.plan_status == PLAN_STATUS_PUBLISHED
      self.plan_status = PLAN_STATUS_CHANGED
      self.save! if update
    end  
  end
  
  protected
    def ignore_attributes 
      [self.class.primary_key, self.class.inheritance_column, "plan_status", "plan_version", "created_at", "updated_at"]
    end
end
