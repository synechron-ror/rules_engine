module RulesEngineHelpers
  # Maps a name to a template. Used by the
  #
  #   When /^I should see the "homepage" page$/ do |template_name|
  #
  #
  def template_for(template_name)    
    case template_name
    
    when /^homepage$/
      'index'
      
    else
      path_components = template_name.split(/\s+/)
      path_components.join('_').to_s
    end    
  end

  def debug_page
    puts response.body
  end
  
  def warning(msg)
    puts "********************* #{msg}"    
  end
end

World(RulesEngineHelpers)
