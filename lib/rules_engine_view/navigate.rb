module RulesEngineView
  module Navigate
    
    def re_breadcrumbs *links
      return if links.empty?
      result = ''
      result << '<div class="re-breadcrumbs">'
      links[0 ... -1].each do |link|
        result << link
        result << "<span class='re-breadcrumbs-seperator'>></span>"
      end
      result << "<em>"
      result << "#{links[-1]}"
      result << "</em>"
      result << "<span class='re-breadcrumbs-seperator'>></span>" if links[-1] == links[0]
      result << '</div>'
      # result << '<div class="clear top-5">.</div>'
      result
    end
    
    def re_breadcrumbs_right *links
      return if links.empty?
      result = ''
      result << '<div class="re-breadcrumbs">'
      links[0 ... -2].each do |link|
        result << link
        result << "<span class='re-breadcrumbs-seperator'>></span>"
      end
      result << "<em>"
      result << "#{links[-2]}"
      result << "</em>"
      result << "<span class='re-breadcrumbs-seperator'>></span>" if links[-2] == links[0]
      
      result << "<div class='re-breadcrumb-right'>#{links[-1]}</div>"
      result << '</div>'      
      # result << '<div class="clear top-5">.</div>'
      result            
    end
  end  
end

ActionView::Base.class_eval do
  include RulesEngineView::Navigate
end