# STUB FILE FOR RULES TESTING

class MockRule
  def self.options
    return {:group => 'mock group'}
  end
  
  def self.rule_class_name
    return self.name.classify
  end
end
