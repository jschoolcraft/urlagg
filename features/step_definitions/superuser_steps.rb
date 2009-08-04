Given /^a registered super user "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  Factory.create(:super_user, :login => login, :password => password)
end

Given /^a logged in super user "([^\"]*)"$/ do |login|
  Factory.create(:super_user, :login => login)
  visit admin_login_path
  fill_in "login", :with => login
  fill_in "password", :with => 'root_password'
  click_button("Login")
end