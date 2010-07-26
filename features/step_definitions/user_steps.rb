Given /^a logged in user "([^\"]*)"$/ do |name|
  Given "a registered user \"#{name}\" with password \"secret\""
  Given %{"#{name}" is logged in}
end

Given /^"([^\"]*)" is logged in$/ do |name|
  When "I go to \"the login page\""
  And "I fill in \"Login\" with \"#{name}\""
  And "I fill in \"Password\" with \"secret\""
  And "I press \"Login\""
  Then "I should see \"Currently Tracking\""
  
  @current_user = User.find_by_login!(name)
end