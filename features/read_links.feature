Feature: A user should be able to mark links as read, so they're not shown the next time
  In order only see new links
  As a user
  I want to only see new links after clicking "marked as read"
  
  Scenario: A logged in user sees only new links
    Given a logged in user "Bob"
    And "Bob" is tracking tags "ruby, rails, gtd"
    And the following popular links exist:
      |tag    |link                   |title                |
      |ruby   | http://bar.com/ruby1  |More ruby stuff      |
    When I am on my tags page
    Then I should see "Currently Tracking"
    And I should see:
      |tag    |title                |
      |ruby   |More ruby stuff      |
    When I follow "Mark all read"
    Then I should not see "More ruby stuff"
    And I should see "Sorry, we haven't found any updated links for the tags you are tracking."

  Scenario: A logged in user can mark a single tag as read
    Given a logged in user "Bob"
    And "Bob" is tracking tags "ruby, gtd"
    And the following popular links exist:
      | tag  | link                    | title                |
      | ruby | http://bar.com/ruby1    | More ruby stuff      |
      | gtd  | http://gtdbar.com/ruby1 | Getting things doner |
    When I am on my tags page
    And I follow "mark as read" for tag "ruby"
    Then I should be on my tags page
    And I should not see "More ruby stuff"
    And I should see "Getting things doner"
    