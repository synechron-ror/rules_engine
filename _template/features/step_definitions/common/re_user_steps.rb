##########################################################
# RE_USER_STEPS
#
#   Given I am logged in as a rules engine reader     => @login
#   Given I am logged in as a rules engine editor     => @login

Given /^I am logged in as a rules engine editor$/ do
  @login = User.make(:email => 'mock_login@mockemail.com', :password =>'mock_password', :access_level => ActionController::Base.rules_engine_editor_access_level) 

  visit user_login_path
  fill_in "Email or Login Name", :with => 'mock_login@mockemail.com'
  fill_in "Password", :with => 'mock_password'
  click_button "Login"
end

Given /^I am logged in as a rules engine reader$/ do
  @login = User.make(:email => 'mock_login@mockemail.com', :password =>'mock_password', :access_level => ActionController::Base.rules_engine_reader_access_level) 

  visit user_login_path
  fill_in "Email or Login Name", :with => 'mock_login@mockemail.com'
  fill_in "Password", :with => 'mock_password'
  click_button "Login"
end