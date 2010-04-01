require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RePipelineActivated do

  should_belong_to :re_pipeline, :foreign_key => :parent_re_pipeline_id
end
