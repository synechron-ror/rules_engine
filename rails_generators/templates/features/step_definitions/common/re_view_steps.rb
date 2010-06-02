#---------- VIEWS
# Then I should see the view [template]
# Then I should see the "[link title]" link
# Then I should see the "[link title]" link to [link]
# Then I should see a "[title]" button
#

Then /^I should see the view (.*)$/ do |template_page|
  response.should render_template(template_for(template_page))
end  

Then /^I should see the "([^\"]*)" link$/ do |link_title|
  response.should have_tag("a", :text => link_title)
end

Then /^I should see the "([^\"]*)" link to (.*)$/ do |link_title, link_page|
  response.should have_tag("a[href=#{path_to(link_page)}]", :text => link_title)
end

Then /^I should see a "([^\"]*)" button$/ do |title|
  if title =~ /^Choose File$/ 
    response.should have_tag("input[type=file]")
  else  
    response.should have_tag("input[value=#{title}]")
  end  
end
