##
# $ rails example.com -m http://intraducibles.com/projects/typus/template.txt
##

# Install Typus and friends.

plugin "typus", :git => "git://github.com/fesplugas/typus.git"

rake "typus:misc"
rake "typus:ckeditor"

# Run generators.

generate("scaffold", 
         "Asset asset_file_name:string asset_content_type:string asset_file_size:integer asset_updated_at:datetime", 
         "--skip-timestamps")
generate("scaffold", 
        "Category name:string", 
        "--skip-timestamps")
generate("scaffold", 
         "Page title:string body:text status:string position:integer", 
         "--skip-timestamps")
generate("scaffold", 
         "Post title:string body:text status:string category_id:integer", 
         "--skip-timestamps")

# Define models.

file "app/models/asset.rb", <<-CODE
class Asset < ActiveRecord::Base

  validates_attachment_presence :asset

  has_attached_file :asset, :styles => { :typus_preview => "692x461>", :typus_thumbnail => "100x100>" }

end
CODE

file "app/models/category.rb", <<-CODE
class Category < ActiveRecord::Base

  validates_presence_of :name

  has_many :posts

end
CODE

file "app/models/page.rb", <<-CODE
class Page < ActiveRecord::Base

  STATUS = %w( draft unpublished published )

  acts_as_list

  validates_presence_of :title

end
CODE

file "app/models/post.rb", <<-CODE
class Post < ActiveRecord::Base

  STATUS = { "draft" => "Draft", 
             "unpublished" => "Unpublished post", 
             "published" => "Published post" }

  validates_presence_of :title

  belongs_to :category

  def to_label
    title
  end

end
CODE

# Run the migrations and set the routes.

rake "db:migrate"
run "rm public/index.html"
route "map.root :controller => 'posts'"

# Run the Typus generator and migrate.

generate "typus"
rake "db:migrate"

# Overwrite the file ...
file "config/typus/application.yml", <<-CODE
# Typus Models Configuration File
#
# Use the README file as a reference to customize settings.

Asset:
  fields:
    list: asset_file_name
    form: asset_file_name, asset_content_type, asset_file_size, asset_updated_at
  order_by: 
  relationships: 
  filters: 
  search: asset_file_name
  application: example.com

Category:
  fields:
    list: name
    form: name
  order_by: name
  relationships: posts
  filters: 
  search: name
  application: example.com

Page:
  fields:
    list: title, status, position
    form: title, body, status
    options:
      selectors: status
  order_by: position
  relationships: 
  filters: 
  search: title, body
  application: example.com

Post:
  fields:
    list: title, status, category
    form: title, body, status, category
    options:
      selectors: status
  order_by: 
  relationships: category
  filters: category
  search: title, body
  application: example.com
CODE

file "db/seeds.rb", <<-CODE

lipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

[ "Unknown" ].each do |category|
  Category.create :name => category
end

Post.create :title => "Hello World!", 
            :body => lipsum, 
            :status => "published", 
            :category_id => Category.find_by_name("Unknown")

Page.create :title => "About", 
            :body => lipsum, 
            :status => "draft"

CODE

rake "db:seed"