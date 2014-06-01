# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'sca'
#set :repo_url, 'git@example.com:me/my_repo.git'
set :repo_url, 'file:/media/tpryan/Applications/LinuxRails/SCA/.git'
set :repository, '/media/tpryan/Applications/LinuxRails/SCA/.git'
set :local_repository, 'ssh://'
set :deploy_via, :copy
set :use_sudo, false
set :scm, :git
set :branch, 'master'
set :deploy_to, '/home/deploy/sca'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
  # after :publishing, :restart

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
