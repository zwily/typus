# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "typus/version"

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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "dragonfly", "~> 0.9"
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "paperclip"
  s.add_development_dependency "rack-cache"
  s.add_development_dependency "rails-trash"

  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "rails", "~> 3.1.0.rc3"
end
