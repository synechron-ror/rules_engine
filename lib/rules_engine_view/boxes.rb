module RulesEngineView
  module Boxes
    def re_whitebox(&block)
      result = ''
      result << '<div class="re-whitebox">' 
      result << '<div class="re-whitebox-content">'
      result << capture(&block)
      result << '<div class="clear"></div>'
      result << '</div>'
      result << '</div>'
   
      concat result.html_safe
    end
    
    def re_shadowbox(&block)
      result = ''
      result << '<div class="re-shadowbox-outer">' 
      result << '<div class="re-shadowbox-inner">'
      result << capture(&block)
      result << '<div class="clear"></div>'
      result << '</div>'
      result << '</div>'
   
      concat result.html_safe
    end
    
  end  
end
