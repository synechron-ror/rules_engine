require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

%w(form_for fields_for form_remote_for remote_form_for).each do |action|

  describe action do 
    include RSpec::Rails::HelperExampleGroup
    
    it "should be accessible to rails apps by default" do 
      ActionView::Base.new.methods.should include("re_#{action}")
    end
    
    it "should set the builder to the RulesEngineView::FormBuilder" do
      options = {}
      helper.should_receive(action.to_sym).with("Name", {:builder => RulesEngineView::FormBuilder})
      helper.send("re_#{action}", "Name", options)
    end
  end
  
end
