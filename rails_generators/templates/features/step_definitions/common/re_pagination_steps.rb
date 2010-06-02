#---------- PAGINATION
# Then I should not see pagination
# Then I should see pagination
# Then I should see the first page of pagination
# Then I should see the second page of pagination
# Then I should see a link to the previous page of pagination
# Then I should see a link to the next page of pagination
# Then I should see a disabled link to the previous page of pagination
# Then I should see a disabled link to the next page of pagination
#      
# When I click the next page link
#
# Given pagination setup to show page "[page]" of "[total]" entries for [model] # 10 items per page 
#
Then /^I should not see pagination$/ do
  response.should_not have_tag("div.pagination")  
end

Then /^I should see pagination$/ do
  response.should have_tag("div.pagination")  
end

Then /^I should see the first page of pagination$/ do
  response.should have_tag("div#pager span.current", :text => '1')
end

Then /^I should see the second page of pagination$/ do
  response.should have_tag("div#pager span.current", :text => '2')
end

Then /^I should see a link to the next page of pagination$/ do
  response.should have_tag("div#pager a.next_page")
end

Then /^I should see a link to the previous page of pagination$/ do
  response.should have_tag("div#pager a.prev_page")
end

Then /^I should see a disabled link to the next page of pagination$/ do
  response.should have_tag("div#pager span.disabled.next_page")  
end

Then /^I should see a disabled link to the previous page of pagination$/ do
  response.should have_tag("div#pager span.disabled.prev_page")
end

When /^I click the next page link$/ do
  click_link 'Next »'
end

Given /^pagination setup to show page "([^\"]*)" of "([^\"]*)" entries for ([^\ ]*)$/ do |page, total_entries, model|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil
  
  mock_pagination = [].paginate(:page => page, :per_page => 10, :total_entries => total_entries)
  klass.stub!(:at_page).and_return(mock_pagination)
end 