set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
require 'hoptoad_notifier/capistrano'

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor', 'bundle')
    run "mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}"
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path}; export PATH=/opt/ruby/bin:$PATH; bundle install --production --without test"
  end
end

after "deploy:symlink", "bundler:bundle_new_release"
