##
# Generate a Rails application with typus, typus_cms and typus_settings.
#
#     $ rails new typus-cms -m http://core.typuscms.com/templates/typus-cms.rb
#
# Enjoy!

##
# Add gems to Gemfile
#

gem 'acts_as_list'
gem 'acts_as_tree'
gem 'acts_as_trashable', :git => 'https://github.com/fesplugas/rails-acts_as_trashable.git'
gem 'dragonfly', '~>0.8.1'
gem 'permalink', :git => 'https://github.com/fesplugas/rails-permalink.git'
gem 'typus', :git => "https://github.com/fesplugas/typus.git"
gem 'rack-cache', :require => 'rack/cache'

##
# Update the bundle
#

run "bundle install"
rake "db:setup"

##
# Run generators.
#

generate(:model, "Entry", "title:string", "permalink:string", "content:text", "excerpt:text", "published:boolean", "type:string")
rake "db:migrate"

# Run typus generators.

generate("typus")
generate("typus:migration")

# Migrate again.

rake "db:migrate"

##
# Update routes.
#

run "rm public/index.html"
route "match '/' => redirect('/admin')"

##
# Load extra templates.
#

load_template "http://core.typuscms.com/templates/ckeditor.rb"
