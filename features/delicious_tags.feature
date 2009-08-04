Feature: Increase discovery of things that interest the user
  In order to increase discovery of relevant information
  As a user
  I want to see other taggings from delicious and be able to track them in URLAgg
  
  Scenario Outline: A user looking at his popular links sees delicious and starts tracking some
     Given a logged in user "Bob"
     And "Bob" is tracking tags "ruby, rails, gtd"
     And the tag "<tag>" has popular link "<link>" with title "<title>" and "<source_tags>"
     When I am on my tags page
     Then I should see "<tag>"
     And I should see "<title>"
     And I should see "source tags: <visible_source_tags>"

     Examples:
       | tag   | link                 | title           | source_tags                   | visible_source_tags     |
       | ruby  | http://foo.com/ruby  | Ruby Stuff      | ruby, rails, patterns, design | rails, patterns, design |
       | ruby  | http://bar.com/ruby1 | More ruby stuff | ruby, rails                   | rails                   |
       | rails | http://foo.com/rails | Rails Home      | rails, gtd                    | gtd                     |
       | rails | http://foo.com/ruby  | Ruby Stuff      | rails, some, more, tags       | some, more, tags        |
