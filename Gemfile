source 'http://rubygems.org'

gem "rails", "~> 3.0.20"

gem 'devise', "~> 1.5.4"
gem 'mysql'
gem 'capistrano', '2.13.5'
gem 'capistrano-ext', :require => 'capistrano'
gem "airbrake"
gem "builder", "~> 2.1.2"

# This one actually belongs to the test group, but it raises an exception if it's not bundled in other environments.
gem 'oauth2', :git => 'git://github.com/redstorm/oauth2.git'

group :test do
  gem 'rspec', '>= 2.0.0.beta.19'
  gem 'rspec-rails', '>= 2.0.0.beta.19'
  gem 'sinatra', '~> 1.0'
  gem 'json'
end
