Given /^a logged in user "([^\"]*)"$/ do |name|
  Given "a registered user \"#{name}\" with password \"secret\""
  When "I go to \"the login page\""
  And "I fill in \"login\" with \"#{name}\""
  And "I fill in \"password\" with \"secret\""
  And "I press \"login\""
  Then "I should see \"Currently Tracking\""
end

Given /^"([^\"]*)" is logged in$/ do |name|
  When "I go to \"the login page\""
  And "I fill in \"login\" with \"#{name}\""
  And "I fill in \"password\" with \"secret\""
  And "I press \"login\""
  Then "I should see \"Currently Tracking\""
end