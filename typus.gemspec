require 'lib/typus'

Gem::Specification.new do |s|

  s.name = %q{typus}
  s.version = Typus.version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Francesc Esplugas"]
  s.date = %q{ 2009-05-15 }
  s.email = %q{francesc@intraducibles.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = Dir['**/*']
  s.has_rdoc = true
  s.homepage = %q{http://intraducibles.com/projects/typus}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", 'README.rdoc']
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Effortless backend interface for Ruby on Rails applications. (Admin scaffold generator.)}

  s.add_dependency(%q<mocha>, [">= 0"])

end