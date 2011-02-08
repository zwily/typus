require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'typus/version'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the typus plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate plugin documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Build the gem.'
task :build do
  system "gem build typus.gemspec"
  system "gem install typus-#{Typus::VERSION}.gem"
end

desc 'Build and release the gem.'
task :release => :build do
  system "git commit -m 'Bump version to #{Typus::VERSION}' lib/typus/version.rb"
  system "git tag v#{Typus::VERSION}"
  system "git push && git push --tags"
  system "gem push typus-#{Typus::VERSION}.gem"
  system "git clean -fd && rm -f typus-#{Typus::VERSION}.gem"
  system "git branch -D 3-0-stable"
  system "git checkout -b 3-0-stable && git push -f"
  system "git checkout master"
end

task :deploy do
  system "cd test/fixtures/rails_app && cap deploy"
end

# RUBIES = ["ruby-1.8.7-p330", "ruby-1.9.2-p136", "ree-1.8.7-2010.02", "jruby-1.5.6"]
RUBIES = ["ruby-1.8.7-p330", "ruby-1.9.2-p136", "ree-1.8.7-2010.02"]

namespace :setup do

  desc "Setup test environment"
  task :setup_test_environment do
    RUBIES.each { |ruby| system "rvm install #{ruby}" }
  end

  desc "Setup CI Joe"
  task :cijoe do
    system "git config --add cijoe.runner 'rake -s test:all'"
  end

end

namespace :test do

  task :all do
    system "rm -f Gemfile.lock && bundle install"

    RUBIES.each do |ruby|
      system "bash -l -c 'rvm use #{ruby} && rake && rake DB=postgresql && rake DB=mysql'"
    end
  end

end
