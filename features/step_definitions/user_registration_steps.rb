Given /^no registered users$/ do
  User.delete_all
end

Given /^a registered user "([^\"]*)"$/ do |login|
  Factory.create(:user, :login => login, :password => 'secret', :password_confirmation => 'secret')
end

Given /^a registered user "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  User.delete_all
  Factory.create(:user, :login => login, :password => password, :password_confirmation => password, :email => "bob@example.com")
end