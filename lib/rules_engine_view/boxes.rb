module RulesEngineView
  module Boxes
    def whitebox(&block)
      result = ''
      result << '<div class="whitebox">' 
      result << '<div class="whitebox-content">'
      result << capture(&block)
      result << '<div class="clear"></div>'
      result << '</div>'
      result << '</div>'
   
      concat result
    end
    
    def shadowbox(&block)
      result = ''
      result << '<div class="shadowbox-outer">' 
      result << '<div class="shadowbox-inner">'
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