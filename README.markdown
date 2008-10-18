# Typus

As Django Admin, Typus is designed for a single activity:

    Trusted users editing structured content.

Once installed and configured you can login at <http://application.tld/admin>

Screenshots on the [wiki](http://github.com/fesplugas/typus/wikis)

**Note:** Typus doesn't try to be all the things to all the people.

## Installing

You can view the available tasks running:

    $ rake -T typus
    (in /home/fesplugas/projects/typus_platform)
    rake typus:dependencies  # Install Typus dependencies (paperclip, acts_as_l....
    rake typus:plugins       # Install Typus plugins
    rake typus:roles         # List current roles
    rake typus:seed          # Create TypusUser `rake typus:seed email=foo@bar....

### Configure

This task will copy required assets to the public folder of your Rails 
application, will generate configuration files on 'config' folder and 
will install some required plugins.

    $ script/generate typus_files

Create TypusUsers migration and migrate your database:

    $ script/generate typus_migration
    $ rake db:migrate

And finally create the first user:

    $ rake typus:seed email='youremail@yourdomain.com' RAILS_ENV=production

Now you can start your application and go to http://application.tld/admin/

## Plugin Configuration Options

You can overwrite the following settings:

    Typus::Configuration.options[:app_name]
    Typus::Configuration.options[:app_description]
    Typus::Configuration.options[:per_page]
    Typus::Configuration.options[:form_rows]
    Typus::Configuration.options[:form_columns]
    Typus::Configuration.options[:minute_step]
    Typus::Configuration.options[:email]
    Typus::Configuration.options[:toggle]
    Typus::Configuration.options[:edit_after_create]
    Typus::Configuration.options[:root]
    Typus::Configuration.options[:recover_password]

You can overwrite this settings in the initializer `typus.rb`.

### Disable password recover

You can disable password recover on the login page. By default, password
recovery is enabled.

    Typus::Configuration.options[:recover_password] = false

### Disallow toggle

When you have a boolean on the lists you can toggle it's status from 
true to false and false to true. You can disable this link with:

    Typus::Configuration.options[:toggle] = false

### Redirect to index after create a record

After creating a new record you'll be redirected to the record so 
you can continue editing it. If you prefer to be redirected to the 
main index you can owerwrite the setting.

    Typus::Configuration.options[:edit_after_create] = false

## Configuration file options

If the configuration file is broken you'll see a `typus.yml` text 
on the admin interface.

### Typus Fields

    fields:
      list: name, created_at, category_id, status
      form: name, body, created_at, status
      relationship: name, category_id

NOTE: Upload files only works if you follow `Paperclip` naming 
conventions.

In form fields you can add an '*' at the end of the field making that 
field read-only, this field will be shown in the form but won't be 
editable. Example with the "name" attribute being read-only:

    fields:
      list: name, created_at, category_id, status
      form: name*, body, created_at, status
      relationship: name, category_id

You can even add "virtual fields". For example you have a model and you 
need special attributes like an slug, which is generated from the title.

    ##
    # app/models/post.rb
    #
    class Post < ActiveRecord::Base

      validates_presence_of :title

      def slug
        title.to_url
      end

    end

You can add `slug` a as attribute and it'll be shown on the lists.

    ##
    # config/typus.yml
    Post:
      fields:
        list: title, slug
        form: title

### External Forms

    relationships:
      has_and_belongs_to_many: users
      has_many: projects

### Filters

You can define filters per model on the config file ...

    filters: status, author_id, created_at

Or directly on the model:

    class Post < ActiveRecord::Base

      def self.filters
        [ :status, :author_id, :created_at ]
      end

    end

### Order

Adding minus (-) sign before the attribute will make the order DESC.

    order_by: -attribute1, attribute2

Or directly on the model:

    class Post < ActiveRecord::Base

      def self.order_by
        [ '-attribute1', 'attribute2' ]
      end

    end

### Searches

You can define search filters on typus.yml

    search: attribute1, attribute2

Or directly on the model:

    class Post < ActiveRecord::Base

      def self.search
        [ :attribute1, :attribute2 ]
      end

    end

### Want more actions?

    actions:
      list: notify_all
      form: notify

These actions will only be available on the context <tt>list</tt> and <tt>form</tt> of Typus.

You'll can add those actions to your admin controllers. Example:

    class Admin::NewslettersController < AdminController

      ##
      # Action to deliver emails ...
      def deliver
        ...
        redirect_to :back
      end

    end

For feedback you can use the following flash methods.

- `flash[:notice]` just some feedback.
- `flash[:error]` when there's something wrong.
- `flash[:success]` when the action successfully finished.

### Applications, modules and submodules

To group modules into an application use *application*.

    application: CMS

Each module has submodules grouped using *module*.

    module: Article

Example: (E-Commerce Application)

    Product:
      application: ECommerce
    Client:
      application: ECommerce
    Category:
      module: Product
    Option Type:
      module: Product

Example: (Blog)

    Post:
      application: Blog
    Category:
      application: Blog
    Tag:
      module: Post

## Custom Views

You can add your custom views to match your application requirements. Views 
you can customize.

    index.html.erb
    edit.html.erb
    show.html.erb

### Example

Need a custom view on the Articles listing? 

Under `app/view/typus/articles` add the file `index.html.erb` and 
Typus default listing will be overrided.

## Customize Interface

You can customize the interface by placing on `views/admin` the 
following files.

### Dashboard

    views/typus/_dashboard_sidebar.html.erb
    views/typus/_dashboard_top.html.erb
    views/typus/_dashboard_bottom.html.erb

### Models

    views/admin/MODEL/_index_top.html.erb
    views/admin/MODEL/_index_bottom.html.erb
    views/admin/MODEL/_index_sidebar.html.erb
    views/admin/MODEL/_new_top.html.erb
    views/admin/MODEL/_new_bottom.html.erb
    views/admin/MODEL/_new_sidebar.html.erb
    views/admin/MODEL/_edit_top.html.erb
    views/admin/MODEL/_edit_bottom.html.erb
    views/admin/MODEL/_edit_sidebar.html.erb
    views/admin/MODEL/_show_top.html.erb
    views/admin/MODEL/_show_bottom.html.erb
    views/admin/MODEL/_show_sidebar.html.erb

## Roles

Typus has roles support. You can can add as many roles as you want. 
They are defined in `config/typus_roles.yml` and you can can define 
the allowed actions per role.

    admin:
      TypusUser: crud
      Post: crud
      Category: crud

    editor:
      Post: cu
      Category: cu

Note: CRUD stands for Create, Read, Update and Delete.

## Typus Enabled Plugins

Typus can use external plugins to extend functionality. Some of them 
are available on GitHub licensed under the MIT License.

    http://github.com/fesplugas/simplified_blog/tree/master

You can use them as example on how to integrate your plugins into Typus.

If you have an existing plugin and you want to integrate it with Typus use
the `typus_plugin` generator.

    $ script/generate plugin your_plugin
    $ script/generate typus_plugin your_plugin

Usually a Typus plugin contains `models`, `controllers` & `views.`.

## Acknowledgments

- Isaac Feliu - http://railslab.net
- Jaime Iniesta - http://railes.net
- supercoco9, sd and hydrus (sort_by)
- Laia Gargallo - http://azotacalles.net
- Xavier Noria (fxn) - http://www.hashref.com
- Sergio Espeja - http://github.com/spejman

## Author, contact & bugs

- You can contact me at <francesc.esplugas@gmail.com>
- Recommend me at <http://workingwithrails.com/person/5061-francesc-esplugas>
- Browse source on GitHub <http://github.com/fesplugas/typus/tree/master>
- Visit the wiki <http://github.com/fesplugas/typus/wikis>
- Report bugs <http://github.com/fesplugas/typus/wikis/bugs>

Copyright (c) 2007-2008 Francesc Esplugas Marti, released under the 
MIT license