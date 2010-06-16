##########################################################
# RE_FORM_STEPS
#
#   Then the "[form field]" field should be required
#   Then the "[form field]" field should be blank
#   Then the "[form field]" field should be "[value]"
#   Then the "[form field]" select field should be "[value]"
#   Then the "[form field]" field should be "[model]" "[field]"
#   Then the "[form field]" select field should be "[model]" "[field]"
#   When I enter "[model]" "[field]" as the "[form_field]"

Then /^the "([^\"]*)" field should be required$/ do |form_field|
  field_id = field_labeled(form_field).id
  response.should have_tag("label[for=#{field_id}] + span.re-form-required")
end

Then /^the "([^\"]*)" field should be blank$/ do |form_field|
  begin
    field_named(form_field).value.should be_blank
  rescue
    field_labeled(form_field).value.should be_blank
  end
end

Then /^the "([^\"]*)" field should be "([^\"]*)"$/ do |form_field, value|  
  begin
    field_named(form_field).value.should == value
  rescue
    field_labeled(form_field).value.should == value
  end  
end

Then /^the "([^\"]*)" select field should be "([^\"]*)"$/ do |form_field, value|  
  begin
    field_named(form_field).element.css("option[selected=selected]").first.content.should == value
  rescue
    field_labeled(form_field).element.css("option[selected=selected]").first.content.should == value
  end  
end


Then /^the "([^\"]*)" field should be "([^\"]*)" "([^\"]*)"$/ do |form_field, model, field|  
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil
  
  begin
    field_named(form_field).value.should == tmp_model[field.to_sym]
  rescue
    field_labeled(form_field).value.should == tmp_model[field.to_sym]
  end  
end

When /^I enter "([^\"]*)" "([^\"]*)" as the "([^\"]*)"$/ do |model, field, form_field|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil

  tmp_model = klass.make_unsaved  
  fill_in(form_field, :with => tmp_model[field.to_sym]) 
end