class RePlanWorkflow < ActiveRecord::Base
  default_scope :order => 'position'
  belongs_to :re_plan
  belongs_to :re_workflow
  acts_as_list :scope => :re_plan 
end
