set :user, "fesplugas"
set :application, "demo.typuscms.com"
set :use_sudo, false
set :deploy_to, "/home/#{user}/public_html/#{application}"

set :scm, :git
set :default_run_options, { :pty => true }
set :repository, "git://github.com/fesplugas/typus.git"
set :deploy_via, :remote_cache
set :keep_releases, 2

set :domain, "demo.typuscms.com"

role :web, domain
role :app, domain
role :db, domain, :primary => true # This is where Rails migrations will run
role :db, domain

after "deploy", "deploy:cleanup"
after "deploy:update_code", "my_bundle:install"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}/test/fixtures/rails_app && rake db:setup RAILS_ENV=production"
    run "cd #{current_path}/test/fixtures/rails_app && touch tmp/restart.txt"
  end
end

namespace :my_bundle do

  task :install do
    run "cd #{release_path} && bundle install --path #{shared_path}/bundle --quiet --without development test"
  end

end
