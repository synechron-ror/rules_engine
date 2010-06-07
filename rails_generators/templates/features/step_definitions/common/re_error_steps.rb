##########################################################
# RE_ERROR_STEPS
# 
#   Then the form error message should be "[message]"
#   Then the "([^\"]*)" field should be an error
#
#   Then the error message should not be blank
#   Then the error message should be "[message]"
#   Then the success message should not be blank
#   Then the success message should be "[message]"
#   Then the warning message should not be blank
#   Then the warning message should be "[message]"

Then /^the form error message should be "([^\"]*)"$/ do |msg|
  response.should have_tag('div.errorExplanation') do
    with_tag('p', :text => msg)
  end
end

Then /^the "([^\"]*)" field should be an error$/ do |form_field|
  field_id = field_labeled(form_field).id
  response.should have_tag("div.re-form-label-error > div.fieldWithErrors") do
    with_tag("label", :text => form_field)
  end  
  response.should have_tag("div.re-form-data-error > div.fieldWithErrors") do
    with_tag("input[id=#{field_id}]")
  end  
end

Then /^the error message should not be blank$/ do
  error = flash[:error] || (flash.respond_to?(:now) && flash.now[:error])
  if (error.blank?)
    response.should have_tag('div.error')
  end  
end

Then /^the error message should be "([^\"]*)"$/ do |msg|
  error = flash[:error] || (flash.respond_to?(:now) && flash.now[:error])
  if (error.blank?)
    response.should have_tag('div.error', :text => msg)
  else  
    error.should == msg
  end  
end

Then /^the success message should not be blank$/ do
  success = flash[:success] || (flash.respond_to?(:now) && flash.now[:success])
  if (success.blank?)
    response.should have_tag('div.success')
  end  
end

Then /^the success message should be "([^\"]*)"$/ do |msg|
  success = flash[:success] || (flash.respond_to?(:now) && flash.now[:success])
  if (success.blank?)
    response.should have_tag('div.success', :text => msg)
  else
    success.should == msg  
  end  
end

Then /^the warning message should not be blank$/ do
  warning = flash[:warning] || (flash.respond_to?(:now) && flash.now[:warning])
  if (warning.blank?)
    response.should have_tag('div.notice')
  end  
end

Then /^the warning message shold be "([^\"]*)"$/ do |msg|
  warning = flash[:warning] || (flash.respond_to?(:now) && flash.now[:warning])
  if (warning.blank?)
    response.should have_tag('div.notice', :text => msg)
  else
    warning.should == msg
  end  
end

