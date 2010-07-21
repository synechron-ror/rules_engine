# STUB FILE FOR RULES TESTING
module RulesEngine
  module Rule
    class MockRule < RulesEngine::Rule::Definition
      def self.options
        return {:group => 'mock group'}
      end
    end
  end  
end