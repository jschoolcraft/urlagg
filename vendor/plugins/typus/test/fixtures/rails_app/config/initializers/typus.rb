# Be sure to restart your server when you modify this file.

Typus.setup do |config|
  config.config_folder = Rails.root.join("../config/working")
  config.authentication = :session
end
