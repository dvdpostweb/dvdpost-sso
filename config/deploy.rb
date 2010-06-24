set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} ; export PATH=/opt/ruby/bin:$PATH ; bundle check 2>&1 > /dev/null ; if [ $? -ne 0 ] ; then sh -c 'bundle install --disable-shared-gems --without test' ; fi"
  end
end

after "deploy:symlink", "bundler:bundle_new_release"
