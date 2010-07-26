# Put this in config/application.rb
require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'open-uri'

Bundler.require(:default, Rails.env) if defined?(Bundler) 

module Urlagg
  class Application < Rails::Application
    config.time_zone = 'UTC'    
  end
end

# FETCH_LOG = Logger.new(File.open(Rails.root + '/log/fetch.log', File::WRONLY | File::APPEND | File::CREAT))
