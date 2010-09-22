class RePlanWorkflow < ActiveRecord::Base
  default_scope :order => 'position'
  belongs_to :re_plan
  belongs_to :re_workflow
  acts_as_list :scope => :re_plan 

  scope :order_plan_title, order('re_plans.title ASC')
  scope :by_workflow_id, lambda { |workflow_id| where("re_workflow_id = ?", workflow_id) }
  
end
