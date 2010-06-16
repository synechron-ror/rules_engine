require File.dirname(__FILE__) + '/../spec_helper'

describe RePipelineActivatedObserver do
  def valid_attributes
    {
      :code => "aa_mock",
      :title => "Mock Title"
    }
  end
  
  describe "after create" do
    it "should reset the pipeline activated cache" do
      RePipelineActivated.should_receive(:reset_cache).with('aa_mock')
      RePipelineActivated.create(valid_attributes)
    end
  end
  
  describe "after save" do
    before do
      @pipeline_activated = RePipelineActivated.create(valid_attributes)
    end
    
    it "should reset the pipeline activated cache" do
      RePipelineActivated.should_receive(:reset_cache).with('aa_mock')
      @pipeline_activated.update_attributes(:title => "New Title")
    end
  end
end