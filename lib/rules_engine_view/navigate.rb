module RulesEngineView
  module Navigate
    
    def breadcrumbs *links
      return if links.empty?
      result = ''
      result << '<div class="breadcrumbs">'
      links[0 ... -1].each do |link|
        result << link
        result << '<span>></span>'
      end
      result << "<em>"
      result << "#{links[-1]}"
      result << "</em>"
      result << '<span>></span>' if links[-1] == links[0]
      result << '</div>'
      # result << '<div class="clear top-5">.</div>'
      result
    end
    
    def breadcrumbs_right *links
      return if links.empty?
      result = ''
      result << '<div class="breadcrumbs">'
      links[0 ... -2].each do |link|
        result << link
        result << '<span>></span>'
      end
      result << "<em>"
      result << "#{links[-2]}"
      result << "</em>"
      result << '<span>></span>' if links[-2] == links[0]
      
      result << "<div class='breadcrumb-right'>#{links[-1]}</div>"
      result << '</div>'      
      # result << '<div class="clear top-5">.</div>'
      result            
    end
    
    def subnav heading, *links
      result = ''
      result << '<div class="subnav"><h1 class="subnavheading">'
      result << heading
      result << '</h1><div class="subnavitems"><ul>'
        
      links[0 ... -1].each do |link|
        result << '<li><strong>'
        result << link
        result << ' | '
        result << '</strong></li>'
      end
      result << '<li><strong>'
      result << links[-1]
      result << '</strong></li>'
      
      result << '</ul></div></div>'
      result << '<div class="clear"></div>'
      result
    end
  end  
end

ActionView::Base.class_eval do
  include RulesEngineView::Navigate
end