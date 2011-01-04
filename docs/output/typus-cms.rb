##
# Generate a Rails application with typus, typus_cms and typus_settings.
#
#     $ rails new demo -m http://core.typuscms.com/demo.rb
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
# Download CKEditor and enable it for typus
#

run <<-CMD
mkdir -p public/vendor
cd public/vendor
curl -s -O http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5/ckeditor_3.5.tar.gz
tar xvzf ckeditor_3.5.tar.gz
rm ckeditor_3.5.tar.gz
CMD

file 'public/admin/javascripts/application.js', <<-END
document.write("<script type='text/javascript' src='/vendor/ckeditor/ckeditor.js'></script>"); 

$(function() {
  if ($('textarea').length > 0) {
    var data = $('textarea');
    $.each(data, function(i) { CKEDITOR.replace(data[i].id); });
  }
});
END

file 'public/vendor/ckeditor/config.js', <<-END
/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{

  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';

  config.height = '250px';
  config.width = '690px';

  config.toolbar = 'Easy';
  config.toolbar_Easy =
    [
        ['Source','-','Templates', '-', 'Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Maximize'],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Link','Unlink','Anchor', '-', 'Image','Embed'],
        ['Styles','Format', 'Bold','Italic','Underline','Strike','-', 'TextColor'],
        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ];

};
END
