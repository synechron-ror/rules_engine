module RulesEngineMacros

  def it_should_require_admin_access(action)
    it "should require admin access for #{action}" do
      controller.should_receive(:admin_access_required)
      get action
    end
  end    

  def it_should_require_rules_engine_reader_access(action)
    it "should require rules engine reader access for #{action}" do
      controller.should_receive(:rules_engine_reader_access_required)
      get action
    end
  end    

  def it_should_require_rules_engine_editor_access(action)
    it "should require rules engine editor access for #{action}" do
      controller.should_receive(:rules_engine_editor_access_required)
      get action
    end
  end    
end  