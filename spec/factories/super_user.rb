Factory.define :super_user do |u|
  u.login { Factory.next(:name) }
  u.password 'root_password'
  u.password_confirmation { |u| u.password }
  u.sequence(:email) { |i| "super_user_#{i}@example.com" }
end
