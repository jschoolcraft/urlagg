# Put this in config/application.rb
require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'open-uri'

# explicit requires from Gemfile/bundler
require 'Authlogic'
require 'atom'

module Urlagg
  class Application < Rails::Application
    config.time_zone = 'UTC'    
  end
end

# FETCH_LOG = Logger.new(File.open(Rails.root + '/log/fetch.log', File::WRONLY | File::APPEND | File::CREAT))
