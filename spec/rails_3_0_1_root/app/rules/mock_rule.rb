# STUB FILE FOR RULES TESTING
module RulesEngine
  module Rule
    class MockRule < RulesEngine::Rule::Definition
      
      def self.rule_class_name
        "mock_rule"
      end      
      
      self.options = 
        {
          :group => 'mock group',
          :display_name => 'mock rule',    
          :help_partial => '/re_rules/mock_rule/help',
          :new_partial => '/re_rules/mock_rule/new',
          :edit_partial => '/re_rules/mock_rule/edit'
        } 
    end
  end  
end