module RulesEngineView
  module Config
    @layout = nil
    def self.layout
      @layout
    end
    
    def self.layout=(layout)  
      @layout = layout
    end
  end    
end
