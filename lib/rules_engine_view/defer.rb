module RulesEngineView
  module Defer

    def set_re_javascript_include(javascript_include_or_array)
      content_for :defer_re_javascript_include do
        javascript_include_tag(javascript_include_or_array)
      end
    end  

    def set_re_breadcrumbs(*crumbs)
      content_for :defer_re_breadcrumbs do
        re_breadcrumbs(*crumbs)
      end
    end

    def set_re_breadcrumbs_right(*crumbs)
      content_for :defer_re_breadcrumbs do
        re_breadcrumbs_right(*crumbs)
      end
    end

    def set_re_subnav(heading, *crumbs)
      content_for :defer_re_subnav do
        re_subnav(heading, *crumbs)
      end
    end
    
  end    
end


ActionView::Base.class_eval do
  include RulesEngineView::Defer
end