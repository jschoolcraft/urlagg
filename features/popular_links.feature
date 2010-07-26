Feature: A user should be able to see the popular links for their tracked tags
  In order to keep up with the intertubes
  As a user
  I want to see the popular links for my tracked tags

  Scenario Outline: A logged in user can see popular links for his tracked tags
     Given a logged in user "Bob"
     And "Bob" is tracking tags "ruby, rails, gtd"
     And the tag "<tag>" has popular link "<link>" with title "<title>"
     When I am on my tags page
     Then I should see "Currently Tracking"
     And I should see a link with title "<title>" under the tag heading "<tag>"

     Examples:
       | tag   | link                                                   | title                | 
       | ruby  | http://foo.com/ruby                                    | Ruby Stuff           | 
       | ruby  | http://bar.com/ruby1                                   | More ruby stuff      | 
       | rails | http://foo.com/rails                                   | Rails Home           | 
       | rails | http://foo.com/ruby                                    | Ruby Stuff           | 
       | gtd   | http://gtd.com/foo                                     | Getting things doner | 
       | gtd   | http://thequeue.net/blog/not-getting-anything-done-gtd | GTD FAIL             | 

  @show-page
  Scenario: Any user can see all popular links for a specific tag
    Given a registered user "Bob" with password "supersecret"
    And "Bob" is tracking tags "ruby"
    And the tag "ruby" has 100 popular links
    When I am on the tag page for "ruby"
    Then I should see "Popular links for ruby"
    And I should see links 1-20 for "ruby"
    And I should not see links 21-100 for "ruby"
    And I should see pagination controls