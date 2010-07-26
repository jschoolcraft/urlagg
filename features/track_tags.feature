Feature: Users can track tags on delicious/popular

  As a user
  I want to be able to track certain tags on delicious/popular
  So that I can cut down my rss consumption and focus on a few specific areas
  
  Scenario: A logged in user can track tags
    Given the following users, tracking tags, with lots of links
      | user | tags                    |
      | bob  | ruby,rails,productivity |
      | fred | ruby,organization       |
    And "bob" is logged in
    And I am on my tags page
    Then I should see "ruby"
    And I should see "rails"
    And I should see "productivity"
    When I fill in "Add tag" with "gtd"
    And I press "Track"
    Then I should see "Now tracking gtd"
  
  Scenario: A logged in user only sees his tracked tags
    Given the following users, tracking tags, with lots of links
      | user | tags                                       |
      | bob  | ruby,rails,gtd                             |
      | fred | foo,bar,baz,bo,do,re,me,fa,photography,gtd |
    And "bob" is logged in
    When I am on my tags page
    Then I should see "Currently Tracking"
    And I should see "ruby"
    And I should see "rails"
    And I should see "gtd"
    And I should not see "photography"
  Scenario: A logged in user can stop tracking tags
    Given the following users, tracking tags, with lots of links
      | user | tags                          |
      | bob  | ruby,photography,productivity |
    And "bob" is logged in
    And I am on my tags page
    When I follow "photography"
    Then I should see "Popular links for photography"
    When I follow "Stop tracking"
    Then I should see "Stopped tracking photography"
    And I should see "ruby"
    And I should see "productivity"
  
  Scenario: A user should not be able to track an empty tag
    Given a logged in user "Bob"
    And I am on my tags page
    When I press "Track"
    Then I should see "Currently Tracking"  
  
  Scenario: A user on the tags page from a source tag not yet tracked in URLAgg can start tracking it
    Given a logged in user "Bob"
    When I am on the tag page for "a-tag-not-tracked"
    Then I should see "URLAgg is not tracking a-tag-not-tracked."
    When I follow "Start tracking a-tag-not-tracked"
    Then I should see "Now tracking a-tag-not-tracked"
  
  Scenario: A user should not see "stop tracking" on a tag he's not tracking
    Given a logged in user "Bob"
    And a registered user "Phil"
    And "Bob" is tracking tags "ruby, rails"
    And "Phil" is tracking tags "photography, ruby"
    When I am on the tag page for "photography"
    Then I should not see "Stop tracking photography"
  
  Scenario Outline: Should be able to track tags with special characters
    Given a logged in user "Bob"
    And I am on my tags page
    And I fill in "Add tag" with "<tag>"
    When I press "Track"
    Then I should see "Currently Tracking"
    And I should see "<tag>"
    
    Examples:
      | tag     |
      | ASP.NET |
      | web2.0  |
  
  Scenario: A user should be able to track a new tag from the tag page
    Given a logged in user "Bob"
    And a registered user "Phil"
    And "Bob" is tracking tags "ruby, rails"
    And "Phil" is tracking tags "photography, ruby"
    And I am on the tag page for "photography"
    When I follow "Start tracking photography"
    Then I should see "Now tracking photography"
  
  Scenario Outline: An anonymous user can see the top 9 tracked tags
    Given the following users, tracking tags, with one link
      | user  | tags                                                           |
      | bob   | ruby,gtd,productivity,startups,iphone                          |
      | fred  | ruby,gtd,productivity,startups,iphone                          |
      | larry | ruby,gtd,productivity,startups,iphone,foo,bar,code,development |
      | moe   | foo,bar,code,development,baz2,baz3,baz4,baz5                   |
    When I am on the homepage
    And I follow "Top Tags"
    Then I should see "Top 9 most tracked tags on URLAgg"
    And I should see "<tag>"
    Examples:
      | tag          |
      | ruby         |
      | gtd          |
      | productivity |
      | startups     |
      | iphone       |
      | foo          |
      | bar          |
      | code         |
      | development  |
  
  Scenario Outline: An anonymous user can see the first 10 links for a top tracked tag
    Given the following users, tracking tags, with lots of links
      | user | tags |
      | bob  | ruby |
    When I am on the homepage
    And I follow "Top Tags"
    Then I should see "Top 9 most tracked tags on URLAgg"
    And I should see "<tag>"
    And I should see "Link-10"
    And I should not see "Link-11"
    And I should not see "source tags:"
    Examples:
      | tag          |
      | ruby         |
