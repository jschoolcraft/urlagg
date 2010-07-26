@ignore
Feature: An administrator of the site should be able to log in

  Scenario: A registered super user can login and be directed to their tags page
    Given a registered super user "root" with password "sekrit"
    When I go to the admin login page
    And I fill in "Login" with "root"
    And I fill in "Password" with "sekrit"
    And I press "Login"
    Then I should be redirected to the admin dashboard page

  Scenario: A logged in super user should be able to logout
    Given a logged in super user "root"
    When I go to the admin logout page
    Then I should be redirected to the homepage
    
  Scenario Outline: A registered super user that types in the wrong password can not login
    Given a registered super user "root" with password "supersecret"
    When I go to the admin login page
    And I fill in "Login" with "<login>"
    And I fill in "Password" with "<password>"
    And I press "Login"
    Then I should see "Login failed"
    
    Examples:
      |login|password|
      |bob  |        |
      |     |        |
      |bbo  |supersecret   |
      |bob  |wrong-password|

  Scenario: An unauthenticated super user should be shown the login page for protected pages
    Given a registered super user "root" with password "supersecret"
    When I go to the admin dashboard page
    Then I should be redirected to the homepage