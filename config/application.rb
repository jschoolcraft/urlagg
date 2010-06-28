# Put this in config/application.rb
require File.expand_path('../boot', __FILE__)
# require 'open-uri'

module Urlagg
  class Application < Rails::Application
    config.time_zone = 'UTC'    
  end
end

# FETCH_LOG = Logger.new(File.open(RAILS_ROOT + '/log/fetch.log', File::WRONLY | File::APPEND | File::CREAT))
