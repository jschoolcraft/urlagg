Feature: Sidebar nav and information features
  In order to show users their tracked tags and help them discover other tags
  As a site owner
  I want to show stuff in the sidebar

  Scenario: A logged in user should see all the tags they are tracking in a sidebar on the tracked tags page
    Given a logged in user "Bob"
    And "Bob" is tracking tags "ruby, rails, productivity, gtd"
    When I am on my tags page
    Then I should see tags "ruby, rails, productivity, gtd" in my sidebar under "All tracked tags"
  
  Scenario: A logged in user should see all the tags they are tracking in a sidebar on a tag page
    Given a logged in user "Bob"
    And "Bob" is tracking tags "ruby, rails, productivity, gtd"
    When I am on the tag page for "gtd"
    Then I should see tags "ruby, rails, productivity, gtd" in my sidebar under "All tracked tags"

  Scenario: A user should be able to see recently tracked tags from other users on the tracked tags page
    Given a logged in user "Bob"
    And a registered user "Phil"
    And "Bob" is tracking tags "ruby, rails"
    And "Phil" is tracking tags "photography, gtd, organization, productivity, photography, design, iphone"
    And I am on my tags page
    Then I should see tags "ruby, rails, productivity, gtd, organization" in my sidebar under "URLAgger trackings"
    
  Scenario: A user should be able to see recently tracked tags from other users on a tag page
    Given a logged in user "Bob"
    And a registered user "Phil"
    And "Bob" is tracking tags "ruby, rails"
    And "Phil" is tracking tags "photography, gtd, organization, productivity, photography, design, iphone"
    And I am on the tag page for "ruby"
    Then I should see tags "ruby, rails, productivity, gtd, organization" in my sidebar under "URLAgger trackings"
      
  Scenario: An anonymous user should be able to see recently tracked tags from other users on a tag page
    Given a registered user "Bob"
    And a registered user "Phil"
    And "Bob" is tracking tags "ruby, rails"
    And "Phil" is tracking tags "photography, gtd, organization, productivity, photography, design, iphone"
    And I am on the tag page for "ruby"
    Then I should see tags "ruby, rails, productivity, gtd, organization" in my sidebar under "URLAgger trackings"

  Scenario: An user should be able to see URLAgg specific tags
    Given a registered user "Bob"
    And "Bob" is tracking tags "ruby, rails"
    When I am on the tag page for "ruby"
    Then I should see tags "hot, popular" in my sidebar under "Magic Tags"
  