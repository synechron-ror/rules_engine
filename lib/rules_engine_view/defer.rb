module RulesEngineView
  module Defer
    
    @prefix_breadcrumbs = nil
    def self.prefix_breadcrumbs
      @prefix_breadcrumbs
    end
    def self.prefix_breadcrumbs=(prefix)  
      @prefix_breadcrumbs = prefix  
    end
    
    def set_re_javascript_include(javascript_include_or_array)
      content_for :defer_re_javascript_include do
        javascript_include_tag(javascript_include_or_array)
      end
    end  

    def set_re_breadcrumbs(*crumbs)
      content_for :defer_re_breadcrumbs do
        if RulesEngineView::Defer.prefix_breadcrumbs
          re_breadcrumbs(*([RulesEngineView::Defer.prefix_breadcrumbs] << crumbs).flatten)
        else  
          re_breadcrumbs(*crumbs)
        end  
      end
    end

    def set_re_breadcrumbs_right(*crumbs)
      content_for :defer_re_breadcrumbs do
        if RulesEngineView::Defer.prefix_breadcrumbs
          re_breadcrumbs_right(*([RulesEngineView::Defer.prefix_breadcrumbs] + crumbs).flatten)
        else  
          re_breadcrumbs_right(*crumbs)
        end  
      end
    end
  end    
end
