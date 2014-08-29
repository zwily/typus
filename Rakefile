require_relative "test/dummy/config/environment"

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

desc "alias for test:all"
task :default => :"test:all"

namespace :test do

  Rake::TestTask.new("without_features") do |t|
    t.description = "run all tests except the features"
    t.libs += %w(lib test)
    t.test_files = FileList['test/**/*_test.rb'] - FileList['test/features/*_test.rb']
  end

  Rake::TestTask.new("features") do |t|
    t.description = "run feature tests, which use a headless browser"
    t.libs += %w(lib test)
    t.test_files = FileList['test/features/*_test.rb']
  end

  # right now it is better to run without_features and features separately since they need
  # a different test setup (feature specs ran with SQLite require use_transactional_fixtures to be 
  # to prevent db file locking issues).
  task all: [:without_features, :features]

end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end