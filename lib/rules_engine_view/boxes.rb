module RulesEngineView
  module Boxes
    def re_whitebox(&block)
      result = ''.html_safe
      result << '<div class="re-whitebox">'.html_safe
      result << '<div class="re-whitebox-content">'.html_safe
      result << capture(&block)
      result << '<div class="clear"></div>'.html_safe
      result << '</div>'.html_safe
      result << '</div>'.html_safe
   
      concat result
    end
    
    def re_shadowbox(&block)
      result = ''.html_safe
      result << '<div class="re-shadowbox-outer">'.html_safe
      result << '<div class="re-shadowbox-inner">'.html_safe
      result << capture(&block)
      result << '<div class="clear"></div>'.html_safe
      result << '</div>'.html_safe
      result << '</div>'.html_safe
   
      concat result
    end
    
  end  
end
