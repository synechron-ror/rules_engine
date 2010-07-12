require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePlanWorkflow do
  should_belong_to :re_plan
  should_belong_to :re_workflow
end
