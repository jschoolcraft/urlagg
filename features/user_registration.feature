Feature: Account registration

  As an anonymous user
  I want to create an account on this site
  So that I can use it, cuz it's awesome
  
  Background:
    Given the following tracked tags with popular links
      | tag     | link                | title                | days_ago |
      | hot     | http://foo.com/ruby | Ruby Home page       | 0        |
      | hot     | http://bar.com      | Barcamp              | 0        |
      | popular | http://asp.net      | ASP.NET MVC          | 0        |
      | popular | http://gtd.com/foo  | Getting things doner | 0        |
  
  Scenario: Anonymous user registering for a new account
    Given no registered users
    And there are links for the tag "popular"
    When I go to the registration page
    And I fill in "Login" with "John"
    And I fill in "Email" with "john@foo.com"
    And I fill in "Password" with "secret"
    And I fill in "Password confirmation" with "secret"
    And I press "Create account"
    Then I should see "Account registered!"
    And I should see "Currently Tracking"
    And I should see "popular"
    And I should see "hot"

  Scenario: Anonymous user must enter valid data to register for an account
    Given no registered users
    When I go to the registration page
    And I fill in "Login" with "John"
    And I fill in "Email" with "john"
    And I fill in "Password" with "secret"
    And I fill in "Password confirmation" with "not a secret"
    And I press "Create account"
    Then I should see "prohibited"
  
