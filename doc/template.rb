# To Run:
#
#     rails new typus-demo -m https://raw.github.com/typus/typus/master/doc/template.rb
#     rails new typus-demo -m ~/Development/typus/doc/template.rb
#

# Generate some stuff
generate :model, 'Entry title:string'
rake 'db:migrate'

# Add Typus to Gemfile and run generator
gem 'typus', github: 'typus/typus'
run 'bundle install'
generate 'typus'
generate 'typus:migration'
rake 'db:migrate'

# Redirect root to admin
root :to => redirect('/admin')
