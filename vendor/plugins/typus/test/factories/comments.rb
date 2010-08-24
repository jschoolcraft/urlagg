Factory.define :comment do |f|
  f.name "John"
  f.email "john@example.com"
  f.body "Body of the comment"
  f.association :post
end
