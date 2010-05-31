raise 'First use: Verify configuration first !'

#############################################################
#	Application
#############################################################

set :application, "sso"
set :deploy_to, "/home/webapps/sso/production"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production"

#############################################################
#	Servers
#############################################################

set :user, "sso"
set :domain, "sso.dvdpost.be"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "production"
set :scm_user, 'sso'
set :scm_passphrase, "L035t3rz"
set :repository, "git@github.com:redstorm/dvdpost-sso.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    production:
      adapter: mysql
      encoding: utf8
      username: sso
      password: L035t3rz
      database: sso_production
      host: db.x0.sso.be
    EOF

    put db_config, "#{release_path}/config/database.yml"
  end

  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end
