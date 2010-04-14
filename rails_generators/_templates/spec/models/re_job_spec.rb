require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReJob do
  def valid_attributes
    {
      :job_status => ReJob::JOB_STATUS_NONE
    }
  end
  
  should_validate_presence_of :job_status
  
  it "should be valid with valid attributes" do
    ReJob.new(valid_attributes).should be_valid
  end

  should_have_many :re_job_audits
  
end
