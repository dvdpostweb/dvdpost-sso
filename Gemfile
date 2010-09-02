source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'
gem 'devise', :git => 'git://github.com/jeroenj/devise.git', :branch => 'legacy'
gem 'mysql'

gem 'hoptoad_notifier'

# This one actually belongs to the test group, but it raises an exception if it's not bundled in other environments.
gem 'oauth2', :git => 'git://github.com/redstorm/oauth2.git'

group :test do
  gem 'sqlite3-ruby'
  gem 'rspec', '>= 2.0.0.beta.19'
  gem 'rspec-rails', '>= 2.0.0.beta.19'
  gem 'sinatra', '~> 1.0'
  gem 'json'
end
