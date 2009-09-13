@wip
Feature: A valid user should be able to authenticate with the site

  As a valid user
  I want to log in
  So that I can see my tags or use the site (TBD)
  
  Scenario: A user should be able to get to the login page
    Given a registered user "bob" with password "supersecret"
    When I go to the homepage
    Then I should see "URLAgg"
    When I follow "Log in"
    Then I am on the login page
    
  Scenario: A registered user can login and be directed to their tags page
    Given a registered user "bob" with password "supersecret"
    When I go to the login page
    And I fill in "Login" with "bob"
    And I fill in "Password" with "supersecret"
    And I press "Login"
    Then I should see "Currently Tracking"

  Scenario: A registered user should be able to logout
    Given a logged in user "Bob"
    When I go to the logout page
    Then I should see "Successfully logged out"
    
  Scenario: A logged in user on the login page should just redirect to their tags page
    Given a logged in user "Bob"
    When I go to the login page
    Then I should see "Currently Tracking"
    
  Scenario: A logged in user should be able to logout
    Given a logged in user "Bob"
    And I am on my tags page
    When I follow "Log out"
    Then I should see "Successfully logged out"
    
  Scenario Outline: A registered user that types in the wrong password can not login
    Given a registered user "bob" with password "supersecret"
    When I go to the login page
    And I fill in "Login" with "<login>"
    And I fill in "Password" with "<password>"
    And I press "login"
    And I should see "prohibited"
    
    Examples:
      |login|password|
      |bob  |        |
      |     |        |
      |bbo  |supersecret   |
      |bob  |wrong-password|

  Scenario Outline: An unauthenticated user should be shown the login page for protected pages
    Given a registered user "bob" with password "supersecret"
    When I go to <page>
    Then I should see "Please login"

    Examples:
      |page|
      |my tags page|
      
  Scenario: An unauthenticated user should not see "Track this tag" on tag pages
    Given a registered user "bob" with password "supersecret"
    And "bob" is tracking tags "ruby, rails"
    When I go to the tag page for "ruby"
    Then I should not see "Start tracking ruby"