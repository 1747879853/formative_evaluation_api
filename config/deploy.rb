# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "formative_evaluation_api"
set :repo_url, 'ssh://passenger@127.0.0.1/home/passenger/formative_evaluation_api.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/wisdom_secretary_api"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "public/_attachment", "lib/approvalmodel","public/course_outline","public/homework_img"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# rvm setting
set :rvm_ruby_version, '2.3.1'
set :rvm_type, :user
set :rvm_custom_path, '/usr/share/rvm'
set :passenger_restart_with_touch, true

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:stage)  do
          execute :bundle, "exec rake db:seed"
        end
      end
    end
  end
end