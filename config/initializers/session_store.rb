# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_urlagg_session',
  :secret      => '4491bc0fa5cba65e002355833fed04a6395cd4412fe0f9bc8e1cc1501fb8cd9221c230c1853bb9adca1bb0014aac8ecfea96a5962582eac8d8caabe75f803991'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
