Factory.define :link do |l|
  l.title { "link-#{Factory.next(:name)}" }
  l.url { "http://#{Factory.next(:url)}" }
  l.summary "some summary"
end

Factory.define :bookmarked_link, :parent => :link do |l|
  l.bookmarks  Link.threshold + 1
end

Factory.sequence :name do |n|
  "name-#{n}"
end

Factory.sequence :url do |u|
  "www.example-#{u}.com"
end