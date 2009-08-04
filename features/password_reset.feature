Feature: User should be able to reset their password

  As a user that forgot their password
  I want be able to reset their password
  So that they can log in and use the site
  
  Scenario: A registered user that forgot his password should be able to remember it
    Given a registered user "bob" with password "supersecret"
    When I go to the login page
    And I follow "forgot password?"
    And I fill in "email" with "bob@example.com"
    And I press "Reset my password"
    Then I should see "An email has been sent with instructions to reset your password"
    And I should receive an email
    When I open the email
    Then I should see "Password Reset Instructions" in the subject
    When I click the first link in the email
    Then I should see "Reset Password"
    And I fill in "password" with "newpassword"
    And I fill in "password confirmation" with "newpassword"
    And I press "Update my password and log me in"
    Then I should see "Password has been changed"
    And I should see "Welcome bob"
    
  Scenario: A user must have a valid token to reset their password
    Given no registered users
    When I go to password reset page
    Then I should see "sorry"