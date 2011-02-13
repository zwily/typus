source 'http://rubygems.org'

gemspec

gem 'acts_as_list'
gem 'acts_as_tree'
gem 'dragonfly', '~>0.8.1'
gem 'factory_girl'
gem 'paperclip'
gem 'rack-cache', :require => 'rack/cache'
gem 'rails', '~> 3.0'

group :test do
  gem 'shoulda'

  gem 'mocha'
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

  platforms :jruby do
    gem 'activerecord-jdbc-adapter'
    gem 'jdbc-sqlite3'
  end

  platforms :ruby do
    gem 'sqlite3'
  end

end
