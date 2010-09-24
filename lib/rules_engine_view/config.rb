module RulesEngineView
  module Config
    
    @prefix_breadcrumbs = nil
    def self.prefix_breadcrumbs
      @prefix_breadcrumbs
    end
    def self.prefix_breadcrumbs=(prefix)  
      @prefix_breadcrumbs = prefix  
    end

    @layout = nil
    def self.layout
      @layout
    end
    def self.layout=(layout)  
      @layout = layout
    end
    
  end    
end
