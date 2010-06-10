class SimpleRule < RulesEngine::Rule

  self.options = 
    {
      :group => 'Sample Rules',
      :display_name => 'Simple Rule',
      :help_partial => '/re_rule_definitions/simple_rule/help',
      :new_partial => '/re_rule_definitions/simple_rule/new',
      :edit_partial => '/re_rule_definitions/simple_rule/edit'
    } 
  
  attr_reader :title
  
  def attributes=(params)
    values = params.symbolize_keys
    @title = values[:simple_title]
  end
  
  def verify
    return "Title required" if @title.blank?
    nil
  end

  # def load_from_model(re_rule)
  #   @title = re_rule.title
  #   true
  # end
  # 
  # def save_to_model(re_rule)
  #   it "should set the rule class" do
  #     rule = mock('rule')
  #     rule.should_receive(:rule_class_name=).with("MockRule")
  #     MockRule.new.save(rule).should == true
  #   end
  #   re_rule.title = @title
  #   re_rule.summary = "Simple Rule : Does Nothing"
  #   re_rule.data = ["ignore"].to_json
  #   re_rule.error = nil
  #   true
  # end    
    
end
