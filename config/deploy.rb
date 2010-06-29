set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

namespace :deploy do
  task :bundle_gems do
    run "cd #{current_path} && export PATH=/opt/ruby/bin:$PATH && bundle install --without test --relock"
  end
end

after 'deploy:symlink', 'deploy:bundle_gems'
