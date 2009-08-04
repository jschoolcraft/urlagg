Feature: User profile information
  In order to update my profile
  As a user
  I want to update my profile (bleh)
    
  Scenario: A user must be logged on to see their account information
    Given no registered users
    When I go to user's profile page
    Then I should see "You must be logged in to access this page"
    
  Scenario: A user should be able to update their profile
    Given a logged in user "Bob"
    When I go to user's profile page
    And I follow "edit"
    And I fill in "email" with "new-email@example.com"
    And I press "update"
    Then I should see "Account updated!"
  
  Scenario: A user shouldn't be able to update their profile with bad data
    Given a logged in user "Bob"
    When I go to user's profile page
    And I follow "edit"
    And I fill in "email" with "not-an-email"
    And I press "update"
    Then I should see "email"
    
  Scenario: A logged in user shouldn't be able to create a new account
    Given a logged in user "Bob"
    When I go to the registration page
    Then I should see "must be logged out"  
  
  