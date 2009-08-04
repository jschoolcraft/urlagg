Feature: As the administrator of the site give me quick access to information
  In order to do lots of stuff
  As an administrator
  I want to see reports and stuff

  Background:
    Given a logged in super user "root"
  
  Scenario: Admin can see links
    Given I am on the admin dashboard page
    When I follow "All Links"
    Then I should be on the admin links page
    And I should see "Links"

  Scenario: Admin can see link reports
    Given I am on the link reports page
    Then I should see "Quick Facts"
    And I should see "Distribution"
    
  Scenario: Admin can see all tags
    Given I am on the admin dashboard page
    When I follow "All Tags"
    Then I should be on the admin tags page
    And I should see "Tags"
  
  Scenario: Admin can see all users
    Given I am on the admin dashboard page
    When I follow "All Users"
    Then I should be on the admin users page
    And I should see "Users"
    
  Scenario: Admin can sort links
    Given the following users, tracking tags, with lots of links
        | user | tags |
        | bob  | ruby |
    And I am on the admin links page
    When I follow "Title"
    Then I should be on the admin links page
    When I follow "Bookmarks"
    Then I should be on the admin links page
  
  
  