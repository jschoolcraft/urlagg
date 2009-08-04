Factory.define :tag do |u|
  u.name { "tag-#{Factory.next(:name)}" }
end

Factory.sequence :name do |n|
  "name-#{n}"
end