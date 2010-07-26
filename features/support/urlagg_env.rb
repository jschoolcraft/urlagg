require 'email_spec'
require 'email_spec/cucumber'
require 'factory_girl'
Dir[File.expand_path(File.dirname(__FILE__) + "/../../spec/factories/*.rb")].each {|f| require f}

After("@show-page") do |scenario|
  if scenario.failed?
    save_and_open_page
  end
end