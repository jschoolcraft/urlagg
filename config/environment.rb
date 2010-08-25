# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Urlagg::Application.initialize!

Urlagg::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "urlagg.com",
    :user_name            => ENV['GMAIL_USERNAME'],
    :password             => ENV['GMAIL_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

  config.action_mailer.default_url_options[:host] = "urlagg.com"
end