Feature: Give the user information about the site
  In order to let the user know what they're getting into
  As a site owner
  I want to give people some basic information
  
  Scenario: A user hits the about page
    Given a registered user "bob"
    When I am on the about page
    Then I should see "About URLAgg"
  
  Scenario: A user hits the contact page
    Given a registered user "bob"
    When I am on the contact page
    Then I should see "Contact URLAgg"
    And I should see "The Queue Incorporated"
    And I should see "support@urlagg.com"
    
  Scenario: A user hits the home page
    Given a registered user "bob"
    When I am on the homepage
    Then I should see "Welcome to URLAgg"
    And I should see "information overload"
  
  
  


