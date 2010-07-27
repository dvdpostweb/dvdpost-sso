set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
require 'hoptoad_notifier/capistrano'

namespace :bundler do
  task :install, :roles => :app do
    run "cd #{release_path}; export PATH=/opt/ruby/bin:$PATH; bundle install vendor --disable-shared-gems --without test"
  end
end

after 'deploy:symlink', 'bundler:install'
