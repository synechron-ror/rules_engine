module RulesEngineMacros

  def it_should_require_rules_engine_reader_access(*action)
    it "should require rules engine reader access for #{action[0]}" do
      controller.should_receive(:rules_engine_reader_access_required)
      get *action
    end
  end    

  def it_should_require_rules_engine_editor_access(*action)
    it "should require rules engine editor access for #{action[0]}" do
      controller.should_receive(:rules_engine_editor_access_required)
      get *action
    end
  end    
end  