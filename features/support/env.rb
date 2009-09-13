ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'spork'

Spork.prefork do
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails/world'
  require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
  Cucumber::Rails.use_transactional_fixtures
  Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                                # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

  require 'webrat'

  Webrat.configure do |config|
    config.mode = :rails
  end

  require 'cucumber/rails/rspec'
  require 'webrat/core/matchers'
  require 'email_spec/cucumber'
end

Spork.each_run do
  # This code will be run each time you run your specs.
  
end
