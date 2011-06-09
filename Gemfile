source 'http://rubygems.org'

# Specify your gem's dependencies in typus.gemspec
gemspec

gem 'sqlite3'
gem 'jquery-rails'

# And this stuff needed for the demo application.
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'factory_girl'

# Asset Management
gem "dragonfly", "~> 0.9"
gem "rack-cache", :require => "rack/cache"
gem "paperclip"

group :test do
  gem 'shoulda-context'
  gem 'mocha' # Make sure mocha is loaded at the end ...
end

group :development, :test do

  platforms :jruby do
    gem 'activerecord-jdbc-adapter', :require => false

    gem 'jdbc-mysql'
    gem 'jdbc-postgres'
    gem 'jdbc-sqlite3'

    gem 'jruby-openssl' # JRuby limited openssl loaded. http://jruby.org/openssl
  end

  platforms :ruby do
    gem 'mysql2'
    gem 'pg'
    gem 'sqlite3'
  end

end

group :production do

  # gem 'mongoid'

  platforms :jruby do
    gem 'activerecord-jdbc-adapter'
    gem 'jdbc-sqlite3'
  end

  platforms :ruby do
    # gem 'bson_ext'
    gem 'sqlite3'
  end

end
