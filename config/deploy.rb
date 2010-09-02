set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
require 'hoptoad_notifier/capistrano'
require 'bundler/capistrano'
