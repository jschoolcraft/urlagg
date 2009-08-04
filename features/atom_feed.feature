Feature: Allow users to stay up to date with popular links through an atom feed
  In order to stay up to date with popular links
  As a user
  I want to subscribe to one or more atom feeds
  
  Background:
    Given the following tracked tags with popular links
      | tag     | link                                                   | title                | days_ago |
      | ruby    | http://foo.com/ruby                                    | Ruby Home page       | 2        |
      | ruby    | http://bar.com/ruby1                                   | More ruby stuff      | 0        |
      | rails   | http://foo.com/rails                                   | Rails Home           | 0        |
      | foo     | http://bar.com                                         | Barcamp              | 2        |
      | gtd     | http://thequeue.net/blog/not-getting-anything-done-gtd | GTD FAIL             | 0        |
      | asp.net | http://asp.net                                         | ASP.NET MVC          | 0        |
      | gtd     | http://gtd.com/foo                                     | Getting things doner | 5        |

  
  Scenario Outline: Registered user subscribes to atom feed for all their tracked tags
    Given a logged in user "bob"
    And "bob" is tracking tags "ruby, rails, gtd"
    When I am on my tags page
    And I follow "Atom feed"
    Then I should see "Tags: "
    Then I should <action>
    
    Examples:
      | action                     |
      | see "Ruby Home page"       |
      | see "Rails Home"           |
      | see "Getting things doner" |
      | not see "Barcamp"          |
  
  Scenario Outline: User subscribes to the atom feed for an urlagg tag
    Given a registered user "bob"
    And "bob" is tracking tags "ruby, rails"
    When I am on the tag page for "asp.net"
    And I follow "Atom feed"
    Then I should see "[urlagg] Popular links for asp.net"
    And I should <action>
    
    Examples:
      | action               |
      | see "ASP.NET MVC"    |
      | not see "Rails Home" |
      | not see "GTD FAIL"   |

  Scenario Outline: User subscribes to the summary atom feed for all of a user's tracked tags
    Given a logged in user "bob"
    And "bob" is tracking tags "ruby, rails, gtd, tag-without-links"
    When I am on my tags page
    And I follow "Daily summary feed"
    Then I should see " - Links for bob"
    And I should <action>
  
    Examples:
      | action                         |
      | not see "Ruby home page"       |
      | see "More ruby stuff"          |
      | see "Rails Home"               |
      | see "GTD FAIL"                 |
      | not see "Getting things doner" |
      | not see "tag-without-links"    |
      
  Scenario Outline: User subscribes to the summary atom feed for a tracked tags
    Given a registered user "bob"
    And "bob" is tracking tags "ruby, rails, gtd"
    When I am on the tag page for "asp.net"
    And I follow "Daily summary feed"
    Then I should see "Popular links seen on"
    And I should see "for asp.net"
    And I should <action>
  
    Examples:
      | action                         |
      | not see "Ruby home page"       |
      | see "ASP.NET MVC"              |
      | not see "Rails Home"           |
      | not see "Getting things doner" |
      | not see "GTD FAIL"             |

      
      
