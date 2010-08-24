source "http://rubygems.org"

gem "rails", "3.0.0.rc2"
gem "pg"
gem "authlogic", :git => "git://github.com/odorcicd/authlogic.git", :branch => 'rails3'
gem "json"
gem "ratom", :require => 'atom'
gem "will_paginate", :git => "git://github.com/mislav/will_paginate.git", :branch => "rails3"
gem "haml"
gem "slim_scrooge"
gem "hoptoad_notifier", "~> 2.3.3"

if ["development", "cucumber", "test"].include?(ENV['RAILS_ENV'])
  group :cucumber, :test do
    gem "rspec",                    "2.0.0.beta.20"
    gem "rspec-rails",              "2.0.0.beta.20"
    gem "database_cleaner",         "0.5.2"
    gem 'email_spec',       :git => "git://github.com/bmabey/email-spec.git", :branch => "rails3"
    gem "factory_girl",     :require => false
    gem "autotest",                 "4.3.2", :require => false
    gem "autotest-fsevent",         "0.2.2", :require => false
    gem "autotest-rails",           "4.1.0", :require => false
  end

  group :cucumber do
    gem "cucumber",                 "~> 0.8.3"
    gem "cucumber-rails",           "~> 0.3.2"
    gem "launchy"
    gem "capybara",                 "~> 0.3.9"                 
  end

  group :test do
    gem "remarkable_activerecord",  "4.0.0.alpha4"
  end
end

# gem "big_sitemap", :git => 'http://github.com/alexrabarts/big_sitemap.git'
