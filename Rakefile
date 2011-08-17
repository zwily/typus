begin
  require 'bundler/setup'
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  # t.pattern = 'test/**/*_test.rb'
  t.test_files = FileList['test/app/controllers/**/*_test.rb',
                          'test/app/models/**/*_test.rb',
                          'test/app/mailers/**/*_test.rb',
                          'test/config/*_test.rb',
                          'test/lib/**/*_test.rb']
  t.verbose = false
end

task :default => :test

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus'
  rdoc.options << '--line-numbers'
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

  desc "Install JRuby and update Rubygems to latest version."
  task :jruby_on_lion do
    system "rvm remove jruby"
    system "rvm install --force jruby"
    system "rvm use jruby"
    system "gem install rubygems-update"
    system "update_rubygems"
    system "gem update --system"
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

  desc "Run bundle in all Ruby versions."
  task :gems do
    system "rvm ruby bundle install --gemfile=test/dummy/Gemfile"
  end

end

namespace :test do

  # Typus should be compatible with Ruby 1.8.7 and 1.9.2. Currently tests only
  # pass when using 1.9.2 because on 1.8.7 we get an error because `fastercsv`
  # is not loaded. This is because I've not added that library in the Gemfile.
  desc "Test officially supported Ruby versions and database adapters"
  task :supported do
    system "rvm 1.9.2 rake test DB=sqlite3"
    system "rvm 1.9.2 rake test DB=postgresql"
    system "rvm 1.9.2 rake test DB=mysql"
  end

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
