#----------- FORM FIELDS
# Then I should see the "[form field]" field as required
# Then I should see errors on the "[form_field]" field
# Then the "[form field]" field should be blank
#
# Then I should see the "[model]" value "[field]" in the "[form_field]" field
# When I enter the "[model]" value "[field]" in the "[form_field]" field

Then /^I should see the "([^\"]*)" field as required$/ do |form_field|
  response.should have_tag("label[required=true]", :text => form_field)
end

Then /^I should see errors on the "([^\"]*)" field$/ do |form_field|
  response.should have_tag("div[class=fieldWithErrors]") do
    with_tag("label", :text => form_field)
  end  
end

Then /^the "([^\"]*)" field should be blank$/ do |field|
  field_labeled(field).value.should be_blank
end

Then /^I should see the "([^\"]*)" value "([^\"]*)" in the "([^\"]*)" field$/ do |model, field, form_field|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil
  
  response.should have_tag("div[class*=_form]") do
    with_tag("div[class=form-label]", :text => form_field)
    with_tag("div[class=form-value]", :text => tmp_model[field.to_sym])
  end  
end

When /^I enter the "([^\"]*)" value "([^\"]*)" in the "([^\"]*)" field$/ do |model, field, form_field|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil

  tmp_model = klass.make_unsaved  
  fill_in(form_field, :with => tmp_model[field.to_sym]) 
end

