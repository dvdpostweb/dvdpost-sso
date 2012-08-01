set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require './config/boot'
require 'airbrake/capistrano'
