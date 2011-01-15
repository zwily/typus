default_environment['PATH'] = "/home/fesplugas/.rvm/gems/ruby-1.8.7-p302/bin:/home/fesplugas/.opt/bin:$PATH"

set :user, "fesplugas"
set :application, "demo.typuscms.com"
set :use_sudo, false
set :deploy_to, "/home/#{user}/public_html/#{application}"

set :scm, :git
set :default_run_options, { :pty => true }
set :repository, "git://github.com/fesplugas/typus.git"
set :deploy_via, :remote_cache_with_project_root
set :project_root, "test/fixtures/rails_app"
set :git_enable_submodules, 1
set :keep_releases, 2

set :domain, "demo.typuscms.com"

role :web, domain
role :app, domain
role :db, domain, :primary => true # This is where Rails migrations will run
role :db, domain

before "deploy:restart", "deploy:migrate"
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
