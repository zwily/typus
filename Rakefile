require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the typus plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the typus plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.add ['README.rdoc', 'MIT-LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Typus documentation'
  rdoc.main = 'README.rdoc'
  rdoc.options << '--charset=UTF-8'
  rdoc.options << '--inline-source'
  rdoc.options << '--line-numbers'
end

desc 'Generate specdoc-style documentation from tests'
task :specs do

  puts 'Started'
  timer, count = Time.now, 0

  File.open('SPECDOC', 'w') do |file|
    Dir.glob('test/**/*_test.rb').each do |test|
      test =~ /.*\/([^\/].*)_test.rb$/
      file.puts "#{$1.gsub('_', ' ').capitalize} should:" if $1
      File.read(test).map { |line| /test_(.*)$/.match line }.compact.each do |spec|
        file.puts "- #{spec[1].gsub('_', ' ')}"
        sleep 0.001; print '.'; $stdout.flush; count += 1
      end
      file.puts
    end
  end

  puts "\nFinished in #{Time.now - timer} seconds.\n"
  puts "#{count} specifications documented"

end

begin
  require 'jeweler'
  $LOAD_PATH.unshift 'lib'
  require 'typus/version'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "typus"
    gemspec.summary = "Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator.)"
    gemspec.email = "francesc@intraducibles.com"
    gemspec.homepage = "http://intraducibles.com/projects/typus"
    gemspec.description = "Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator.)"
    gemspec.authors = ["Francesc Esplugas"]
    gemspec.version = Typus::Version
  end
rescue LoadError
  puts "Jeweler not available."
  puts "Install it with: gem install jeweler -s http://gemcutter.org"
end

begin
  require 'sdoc_helpers'
rescue LoadError
  puts "sdoc support not enabled. Please gem install sdoc-helpers."
end

desc "Push a new version to Gemcutter"
task :publish => [ :gemspec, :build ] do
  system "git tag v#{Typus::Version}"
  system "git push origin v#{Typus::Version}"
  system "gem push pkg/typus-#{Typus::Version}.gem"
  system "git clean -fd"
  exec "rake pages"
end

desc "Install the edge gem"
task :install_edge => [ :dev_version, :gemspec, :build ] do
  exec "gem install pkg/typus-#{Typus::Version}.gem"
end

# Sets the current Mustache version to the current dev version
task :dev_version do
  $LOAD_PATH.unshift 'lib/typus'
  require 'typus/version'
  version = Typus::Version + '.' + Time.now.to_i.to_s
  Typus.const_set(:Version, version)
end