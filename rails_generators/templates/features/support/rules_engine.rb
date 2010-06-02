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
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{template_name}\" to a template.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end    
  end

  def debug_page
    puts response.body
  end
  
  def debug_page_text
    doc = Hpricot(response.body)
    puts doc.inner_text.gsub(/^\s*$/, "").squeeze("\n")
  end
  
  def warning(msg)
    puts "********************* #{msg}"    
  end
end

World(RulesEngineHelpers)
