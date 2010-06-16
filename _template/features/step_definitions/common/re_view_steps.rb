##########################################################
# RE_VIEW_STEPS
#
#   Then I should see the view "[template]"
#   Then I should see the "[link title]" link
#   Then I should see the "[link title]" link to [link|the link page]
#   Then I should see the "[title]" button
#
#   Then I should see the "[model]" "[field]" value
#
#   Then I should see the breadcrumb "[title]" link to [link|the link page]
#   Then I should see the breadcrumb "[title]"
    
Then /^I should see the view "(.*)"$/ do |template_page|
  response.should render_template(template_for(template_page))
end  

Then /^I should see the "([^\"]*)" link$/ do |link_title|
  response.should have_tag("a", :text => link_title)
end

Then /^I should see the "([^\"]*)" link to (.*)$/ do |link_title, link_page|
  response.should have_tag("a[href=#{path_to(link_page)}]", :text => link_title)
end

Then /^I should see the "([^\"]*)" button$/ do |title|
  if title =~ /^Choose File$/ 
    response.should have_tag("input[type=file]")
  else  
    response.should have_tag("input[value=#{title}]")
  end  
end

Then /^I should see the "([^\"]*)" "([^\"]*)" value$/ do |model, field|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  response.should contain(tmp_model[field.to_sym])
end

Then /^I should see the breadcrumb "([^\"]*)" link to ([^\"]*)$/ do | link_title, link_page |
  breadcrumbs = response.template.instance_variable_get("@content_for_defer_re_breadcrumbs")
  breadcrumbs.should have_tag("div.re-breadcrumbs a[href=#{path_to(link_page)}]", :text => link_title)
end

Then /^I should see the breadcrumb title "([^\"]*)"$/ do |title|
  breadcrumbs = response.template.instance_variable_get("@content_for_defer_re_breadcrumbs")
  breadcrumbs.should have_tag("div.re-breadcrumbs em", :text => title)
end