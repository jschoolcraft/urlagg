source "http://rubygems.org"

gem "rails", "3.0.0.beta4"
gem "mysql"
gem "authlogic", :git => "git://github.com/odorcicd/authlogic.git", :branch => 'rails3'
gem "json"
gem "ratom", :require => 'atom'
gem "will_paginate", :git => "git://github.com/mislav/will_paginate.git", :branch => "rails3"
gem "haml"
gem "newrelic_rpm", "2.13.0.beta5"
# gem "big_sitemap", :git => 'http://github.com/alexrabarts/big_sitemap.git'
gem "slim_scrooge"  

group :cucumber, :test do
  gem "rspec",                    "2.0.0.beta.14"
  gem "rspec-rails",              "2.0.0.beta.14.1"
  gem "database_cleaner",         "0.5.2"
  gem 'email_spec',       :git => "git://github.com/bmabey/email-spec.git", :branch => "rails3"
  gem "factory_girl",     :require => false
end

group :cucumber do
  gem "cucumber",                 "0.8.3"
  gem "cucumber-rails",           "0.3.2"
  gem "launchy"
  gem "capybara",                 "0.3.9"                 
end

group :test do
  gem "remarkable_activerecord",  "4.0.0.alpha4"
end
