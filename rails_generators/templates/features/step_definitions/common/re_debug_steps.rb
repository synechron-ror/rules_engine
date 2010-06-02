#---------- DEBUG
# Then debug page
# Then debug text
# Then warming "message"

Then /^debug page$/ do
  debug_page
end

Then /^debug text$/ do
  debug_text
end

Then /^warning "([^\"]*)"$/ do |msg|
  warning(msg)
end
