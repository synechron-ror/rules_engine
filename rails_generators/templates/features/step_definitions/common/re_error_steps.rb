#---------- ERRORS
# Then I should see the form errors
# Then I should see an error message
# Then I should see the error message "[message]"
# Then I should see a success message
# Then I should see the success message "[message]"
# Then I should see a warning message
# Then I should see the warning message "[message]"
#

Then /^I should see the form errors$/ do
  response.should have_tag('div.errorExplanation')
end

Then /^I should see an error message$/ do
  response.should have_tag('div.error')    
end

Then /^I should see the error message "([^\"]*)"$/ do |msg|
  response.should have_tag('div.error', msg)
end

Then /^I should see a success message$/ do
  response.should have_tag('div.success')
end

Then /^I should see the success message "([^\"]*)"$/ do |msg|
  response.should have_tag('div.success', msg)
end

Then /^I should see a warning message$/ do
  response.should have_tag('div.notice')
end

Then /^I should see the warning message "([^\"]*)"$/ do |msg|
  response.should have_tag('div.notice', msg)
end
