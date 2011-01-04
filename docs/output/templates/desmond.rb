##
# Generate a Rails application with typus and some extra stuff.
#
#     $ rails new rails-app-desmond -m http://core.typuscms.com/templates/desmond.rb
#
# What will you get?
#
# - Typus with authentication.
# - CMS module if you have access to the private repositories.
# - CKEditor for all your textarea fields.
#
# Enjoy!

# Add gems to Gemfile
apply "http://core.typuscms.com/templates/extras/gems.rb"

# Run generators.
apply "http://core.typuscms.com/templates/extras/private.rb"

# Run typus generators
rake "db:migrate"
generate "typus"
generate "typus:migration"
rake "db:migrate"

# Load extra templates.
apply "http://core.typuscms.com/templates/extras/ckeditor.rb"
