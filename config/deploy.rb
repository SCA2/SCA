# config valid only for current version of Capistrano
lock '3.8.0'

set :application, 'SCA'
set :repo_url, 'git@github.com:SCA2/SCA.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/SCA'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Don't set --binstubs option on bundle install
set :bundle_binstubs, nil

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :figaro do

  desc "SCP transfer figaro configuration to the shared folder"
  task :upload do
    on roles(:app) do
      upload! "config/application.yml", "#{shared_path}/config/application.yml", via: :scp
    end
  end

end

after "deploy:started", "figaro:upload"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

end