module RulesEngineView
  module Navigate
    
    def re_breadcrumbs *links
      return if links.empty?
      result = ''.html_safe
      result << '<div class="re-breadcrumbs">'.html_safe
      links[0 ... -1].each do |link|
        result << link
        result << "<span class='re-breadcrumbs-seperator'>></span>".html_safe
      end
      result << "<em>".html_safe
      result << links[-1]
      result << "</em>".html_safe
      # result << "<span class='re-breadcrumbs-seperator'>></span>" if links[-1] == links[0]
      result << '</div>'.html_safe
      result
    end
    
    def re_breadcrumbs_right *links
      return if links.empty?
      result = ''.html_safe
      result << '<div class="re-breadcrumbs">'.html_safe
      links[0 ... -2].each do |link|
        result << link
        result << "<span class='re-breadcrumbs-seperator'>></span>".html_safe
      end
      result << "<em>".html_safe
      result << links[-2]
      result << "</em>".html_safe
      # result << "<span class='re-breadcrumbs-seperator'>></span>" if links[-2] == links[0]
        
      result << "<div class='re-breadcrumb-right'>".html_safe
      result << links[-1]
      result << "</div>".html_safe
      result << '</div>'.html_safe
      result            
    end
  end  
end
