##########################################################
# RE_DEBUG_STEPS
#
#   Then debug page
#   Then debug text
#   Then warning "[message]"

Then /^debug page$/ do
  debug_page
end

Then /^warning "([^\"]*)"$/ do |msg|
  warning(msg)
end
