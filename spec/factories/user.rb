Factory.define :user do |u|
  u.login { Factory.next(:name) }
  u.password 'secret'
  u.password_confirmation 'secret'
  u.sequence(:email) { |i| "user_#{i}@example.com" }
end

Factory.define :registered_user, :parent => :user do |u|
  u.perishable_token 'foo'
end 