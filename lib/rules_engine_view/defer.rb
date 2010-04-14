module RulesEngineView
  module Defer

    def set_page_title(str="")
      content_for :defer_page_title do
        "#{str}" 
      end
    end

    def set_javascript_include(javascript_include_or_array)
      content_for :defer_javascript_include do
        javascript_include_tag(javascript_include_or_array)
      end
    end  

    def set_breadcrumbs(*crumbs)
      content_for :defer_breadcrumbs do
        breadcrumbs(*crumbs)
      end
    end

    def set_breadcrumbs_right(*crumbs)
      content_for :defer_breadcrumbs do
        breadcrumbs_right(*crumbs)
      end
    end

    def set_subnav(heading, *crumbs)
      content_for :defer_subnav do
        subnav(heading, *crumbs)
      end
    end
    
  end    
end


ActionView::Base.class_eval do
  include RulesEngineView::Defer
end