#require 'sshkit/dsl'
# config valid only for current version of Capistrano
lock '3.4.0'

RUBY_V = '2.2.0'
APP_NAME = 'Team9Scholarships'
ROOT_PATH = "/home/rails_burse/#{APP_NAME}"

set :application, APP_NAME
set :repo_url, 'git@github.com:kitz99/IP-burse.git'
set :branch, ENV['branch'] || 'master'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ROOT_PATH

set :rails_env, 'production'
set :stage, :production
set :rvm_type, :system
#set :rvm_custom_path, '/usr/local/rvm/scripts/rvm'
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :assets do
  desc "precompile assets"
  task :precompile do
    on roles(:app) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec rake assets:precompile RAILS_ENV=production"
    end
  end

  desc "clean assets"
  task :clean do
    on roles(:app) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec rake assets:clean RAILS_ENV=production"
    end
  end
end

namespace :deploy do
  desc "Create log & pid folder"
  task :setup_pid_log do
    on roles(:web) do
      execute "if [ ! -d #{ROOT_PATH}/pid ]; then echo \"Pid folder not found. Creating...\"; mkdir #{ROOT_PATH}/pid; fi && if [ ! -d #{ROOT_PATH}/log ]; then echo \"Log folder not found. Creating...\"; mkdir #{ROOT_PATH}/log; fi"
    end
  end

  desc "Stop unicorn"
  task :stop do
    on roles(:web) do
      execute "if [ ! -f #{ROOT_PATH}/pid/unicorn.pid ]; then echo \"Pid file not found!\"; else kill -s QUIT `cat #{ROOT_PATH}/pid/unicorn.pid`; fi"
    end
  end

  desc "Start unicorn"
  task :start do
    on roles(:web) do
      execute "if [ ! -f #{ROOT_PATH}/pid/unicorn.pid ]; then source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec unicorn_rails -E production -c config/unicorn.rb -D; else echo \"Unicorn already running\"; fi"
    end
  end

  desc "Restart unicorn"
  task :restart do
    on roles(:web) do
      execute "if [ ! -f #{ROOT_PATH}/pid/unicorn.pid ]; then echo \"Pid file not found!\"; else kill -s QUIT `cat #{ROOT_PATH}/pid/unicorn.pid`; fi"
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec unicorn_rails -E production -c config/unicorn.rb -D"
    end
  end

  desc "Setup figaro"
  task :env_var_link do
    on roles(:web) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current/config && rvm use #{RUBY_V} && ln -sf #{ROOT_PATH}/application.yml application.yml"
    end
  end

  desc "Run bundle"
  task :bundle do
    on roles(:web) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle install"
    end
  end

  desc "Run migrations"
  task :migrate_all do
    on roles(:web) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec rake db:create db:migrate RAILS_ENV=production"
    end
  end

  desc "Drop database"
  task :drop_db do
    on roles(:web) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec rake db:drop RAILS_ENV=production"
    end
  end

  desc "Seed database"
  task :seed_db do
    on roles(:web) do
      execute "source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current && rvm use #{RUBY_V} && bundle exec rake db:seed RAILS_ENV=production"
    end
  end

  after :deploy, "deploy:setup_pid_log"
  after :deploy, "deploy:bundle"
  after :deploy, "deploy:env_var_link"
  after :deploy, "deploy:migrate_all"
  after :deploy, "deploy:restart"
end

namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console do
    on roles(:app) do
      exec "ssh -l #{host.user} #{host.hostname} -p #{host.ssh_options[:port]} -t 'source ~/.profile && source /etc/profile.d/rvm.sh && cd #{ROOT_PATH}/current  && rvm use #{RUBY_V} && rails c production'"
     end
  end
end

namespace :logs do
  desc "tail rails logs"
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{ROOT_PATH}/log/unicorn.log"
    end
  end
end
