##
# Generate a Rails application with typus and some extra stuff.
#
#     $ rails new rails-app-desmond -m http://core.typuscms.com/templates/desmond.rb
#
# Enjoy!

##
# Install typus & friends
#

gem 'acts_as_list'
gem 'acts_as_tree'
gem 'acts_as_trashable'
gem 'dragonfly', '~>0.8.1'
gem 'typus', :git => "https://github.com/fesplugas/typus.git"
gem 'rack-cache', :require => 'rack/cache'

##
# Update the bundle
#

run 'bundle install'

##
# Create typus related files ...
#

generate "typus"
generate "typus:migration"

##
# Load extra templates.
#

load_template "http://core.typuscms.com/templates/extras/private.rb"
load_template "http://core.typuscms.com/templates/extras/ckeditor.rb"

##
# Migrate the database!
#

rake "db:migrate"
