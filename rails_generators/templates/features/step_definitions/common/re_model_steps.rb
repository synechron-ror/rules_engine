#---------- MODELS
# Given there is a "[model]"
# Given there is a "[model]" with "[field]" set to "[value]"
# Given the "[model]" has the "[field]" set to "[value]"
# 
# Given the "[model]" is deleted
# Given there are no "[models]" with "[field]" value "[value]"
# Given there are no "[models]"
# 
# Given there are [size] "[models]"
# 
# Then I should see the "[model]" value for "[field]"
# 
# Then there should be an assigned "[model]"
# Then there should be an assigned "[model]" with "[field]" set to "[field_value]"
# 

############################
Given /^there is (?:a|an) "([^\"]*)"$/ do |model|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil
  
  tmp_model = klass.make
  instance_variable_set("@#{model}", tmp_model)
end

Given /^there is (?:a|an) "([^\"]*)" with "([^\"]*)" set to "([^\"]*)"$/ do |model, field, value|
  klass = Kernel.const_get(model.singularize.classify)
  klass.should_not be_nil

  tmp_model = klass.make(field.to_sym => value)
  instance_variable_set("@#{model}", tmp_model)
end

Given /^the ([^\ ]*) has the ([^\ ]*) set to "([^\"]*)"$/ do |model, field, value|
  instance_variable_get("@#{model}").update_attribute field.to_sym, value
end

############################
Given /^the "([^\"]*)" is deleted$/ do |model|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  tmp_model.destroy
end

Given /^there are no "([^\"]*)" with "([^\"]*)" value "([^\"]*)"$/ do |models, field, value|
  klass = Kernel.const_get(models.classify)
  klass.should_not be_nil

  klass.find(:all, :conditions => ["#{field} = ?", value]).each(&:destroy)  
end

Given /^there are no "([^\"]*)"$/ do |models|
  klass = Kernel.const_get(models.classify)
  klass.should_not be_nil

  klass.destroy_all(false)
end

############################
Given /^there are (\d*) "([^\"]*)"$/ do |size, models|
  klass = Kernel.const_get(models.classify)
  klass.should_not be_nil

  records = klass.find(:all)
  # add required users
  records.length.upto(size.to_i - 1) do
    records << klass.make
  end  

  instance_variable_set("@#{models.pluralize}", records)
  records
end

############################
Then /^I should see the "([^\"]*)" value for "([^\"]*)"$/ do |model, field|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  response.should contain(tmp_model[field.to_sym])
end

############################
Then /^there should be an assigned "([^\"]*)"$/ do |model|  
  assigns[model].should_not be_nil  
end

Then /^there should be an assigned "([^\"]*)" with "([^\"]*)" set to "([^\"]*)"$/ do |model, field, field_value|
  assigns[model].should_not be_nil  
  assigns[model][field.to_sym].should == field_value
end


