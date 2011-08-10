require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/app/controllers/**/*_test.rb',
                          'test/app/models/**/*_test.rb',
                          'test/app/mailers/**/*_test.rb',
                          'test/config/*_test.rb',
                          'test/lib/**/*_test.rb']
  t.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :setup do

  desc "Setup CI Joe"
  task :cijoe do
    system "git config --replace-all cijoe.runner 'rake test:rubies'"
  end

end

namespace :install do

  desc "Install REE on Mac OS X Lion"
  task :ree_on_lion do
    system "rvm remove ree"
    system "export CC=/usr/bin/gcc-4.2"
    system "rvm install --force ree"
  end

  desc "Install common Rubies"
  task :rubies do
    system "rvm install 1.8.7,ree,1.9.2,jruby"
  end

  desc "Install latest Rubygems"
  task :latest_rubygems do
    system "rvm ruby gem update --system"
  end

  desc "Install bundler and rake"
  task :bundler_and_rake do
    system "rvm ruby gem install --no-ri --no-rdoc bundler rake"
  end

  desc "Gems"
  task :gems do
    system "rvm ruby bundle install --gemfile=test/fixtures/rails_app/Gemfile"
  end

end

namespace :test do

  # We want to test Typus with all supported databases:
  #
  # - Postgresql
  # - MySQL
  # - SQLite3
  #
  task :rubies do
    system "rvm ruby rake DB=sqlite3"
    system "rvm ruby rake DB=postgresql"
    system "rvm ruby rake DB=mysql"
  end

end

namespace :submodules do

  desc "Update submodules"
  task :update do
    system "git pull && git submodule update --init"
  end

  desc "Upgrade submodules"
  task :upgrade do
    system "git submodule foreach 'git pull origin master'"
    system "git ci -m 'Updated submodules' ."
  end

end