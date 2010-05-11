require 'email_spec'
require 'email_spec/cucumber'
require 'factory_girl'
Dir[File.expand_path(File.dirname(__FILE__) + "/../../spec/factories/*.rb")].each {|f| require f}
