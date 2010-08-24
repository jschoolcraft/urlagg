Factory.define :typus_user do |f|
  f.email "admin@example.com"
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
  f.preferences Hash.new({ :locale => :en })
end
