require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReJobAudit do
  def valid_attributes
    {
      :audit_date => Date.new,
      :audit_code => RulesEngine::RuleOutcome::OUTCOME_START_PIPELINE,
      :audit_success => true
    }
  end
  
  it "should be valid with valid attributes" do
    ReJobAudit.new(valid_attributes).should be_valid
  end
  
  should_belong_to :re_job
  should_belong_to :re_pipeline
  should_belong_to :re_rule
  
  should_validate_presence_of :audit_date
  should_validate_presence_of :audit_code
  # should_validate_presence_of :audit_success
  
end
