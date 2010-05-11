# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'open-uri'

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
end

FETCH_LOG = Logger.new(File.open(RAILS_ROOT + '/log/fetch.log', File::WRONLY | File::APPEND | File::CREAT))
