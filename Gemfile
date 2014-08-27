source 'https://rubygems.org'

# Declare your gem's dependencies in typus.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

platforms :jruby do
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
end

platforms :ruby do
  gem 'mysql2', '~> 0.3.16'
  gem 'pg', '~> 0.17.1'
  gem 'sqlite3', '~> 1.3.9'
end

# Typus can manage lists, trees, trashes, so we want to enable this stuff
# on the demo.
gem 'acts_as_list', github: 'typus/acts_as_list'
gem 'acts_as_tree'
gem 'rails-permalink', '~> 1.0.0'
gem 'rails-trash', github: 'fesplugas/rails-trash'

# We want to be able to use Factory Girl for seeding data.
gem 'factory_girl_rails'

# Rich Text Editor
gem 'ckeditor-rails', github: 'fesplugas/rails-ckeditor'

# Alternative authentication
gem 'devise', github: 'plataformatec/devise'

# Asset Management
gem 'dragonfly', '~> 1.0.7'
gem 'rack-cache', require: 'rack/cache'
gem 'paperclip', '~> 4.2.0'

# MongoDB
gem 'mongoid', github: 'mongoid/mongoid'
