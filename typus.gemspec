# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "typus/version"

files = `git ls-files`.split("\n")
test_files = `git ls-files -- {test}/*`.split("\n")

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "typus"
  s.version = Typus::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Francesc Esplugas"]
  s.email = ["core@typuscms.com"]
  s.homepage = "http://core.typuscms.com/"
  s.summary = "Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator)"
  s.description = "Ruby on Rails Admin Panel (Engine) to allow trusted users edit structured content."

  s.rubyforge_project = "typus"

  s.files         = files - test_files
  s.test_files    = []
  s.require_paths = ["lib"]

  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "rails", "~> 3.1.0.rc6"

  # Development dependencies are defined in the `Gemfile`.
end
