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
   
      concat result
    end
    
    def re_shadowbox(&block)
      result = ''
      result << '<div class="re-shadowbox-outer">' 
      result << '<div class="re-shadowbox-inner">'
      result << capture(&block)
      result << '<div class="clear"></div>'
      result << '</div>'
      result << '</div>'
   
      concat result
    end
    
  end  
end

ActionView::Base.class_eval do
  include RulesEngineView::Boxes
end