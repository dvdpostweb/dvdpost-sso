# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dvdpost-sso_session',
  :secret      => '35d819ffa0585262cf1491e58e5c242bf8aecbc2afbfdde5671897a8c1a911679d3c20031aafe85d31496c08e284d5220b0df243df592f21f375216305e3b9df'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
