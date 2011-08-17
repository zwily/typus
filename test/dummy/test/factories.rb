##
# Auth
##

FactoryGirl.define :admin_user do |f|
  f.sequence(:email) { |n| "admin+#{n}@example.com" }
  f.password "XXXXXXXX"
  f.role "admin"
end

FactoryGirl.define :devise_user do |f|
  f.sequence(:email) { |n| "john+#{n}@example.com"}
  f.password "12345678"
end

FactoryGirl.define :typus_user do |f|
  f.sequence(:email) { |n| "user+#{n}@example.com" }
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
end

##
# CRUD
##

FactoryGirl.define :entry do |f|
  f.sequence(:title) { |n| "Entry##{n}" }
  f.content "Body of the entry"
end

FactoryGirl.define :entry_bulk do |f|
  f.sequence(:title) { |n| "EntryBulk##{n}" }
  f.content "Body of the entry"
end

FactoryGirl.define :entry_trash do |f|
  f.sequence(:title) { |n| "EntryTrash##{n}" }
  f.content "Body of the entry"
end

FactoryGirl.define :case do |f|
  f.sequence(:title) { |n| "Case##{n}" }
  f.content "Body of the entry"
end

##
# CRUD Extended
##

FactoryGirl.define :asset do |f|
  f.sequence(:caption) { |n| "Asset##{n}" }
  f.dragonfly File.new("#{Rails.root}/public/images/rails.png")
  f.dragonfly_required File.new("#{Rails.root}/public/images/rails.png")
  f.paperclip File.new("#{Rails.root}/public/images/rails.png")
  f.paperclip_required File.new("#{Rails.root}/public/images/rails.png")
end

FactoryGirl.define :category do |f|
  f.sequence(:name) { |n| "Category##{n}" }
end

FactoryGirl.define :comment do |f|
  f.sequence(:name) { |n| "Comment##{n}" }
  f.sequence(:email) { |n| "john+#{n}@example.com" }
  f.body "Body of the comment"
  f.association :post
end

FactoryGirl.define :page do |f|
  f.sequence(:title) { |n| "Page##{n}" }
  f.body "Content"
end

FactoryGirl.define :post do |f|
  f.sequence(:title) { |n| "Post##{n}" }
  f.body "Body"
  f.status "published"
end

FactoryGirl.define :view do |f|
  f.ip "127.0.0.1"
  f.association :post
  f.association :site
end

##
# HasOne Association
#

FactoryGirl.define :invoice do |f|
  f.sequence(:number) { |n| "Invoice##{n}" }
  f.association :order
end

FactoryGirl.define :order do |f|
  f.sequence(:number) { |n| "Order##{n}" }
end

##
# HasManyThrough Association
#

FactoryGirl.define :user do |f|
  f.sequence(:name) { |n| "User##{n}" }
  f.sequence(:email) { |n| "user.#{n}@example.com" }
  f.role "admin"
  f.token "qw1rd3-1w3f5b"
end

FactoryGirl.define :project do |f|
  f.sequence(:name) { |n| "Project##{n}" }
  f.association :user
end

FactoryGirl.define :project_collaborators do |f|
  f.association :user
  f.association :project
end

##
# Polymorphic
##

FactoryGirl.define :animal do |f|
  f.sequence(:name) { |n| "Animal##{n}" }
end

FactoryGirl.define :bird do |f|
  f.sequence(:name) { |n| "Bird##{n}" }
end

FactoryGirl.define :dog do |f|
  f.sequence(:name) { |n| "Dog##{n}" }
end

FactoryGirl.define :image_holder do |f|
  f.sequence(:name) { |n| "ImageHolder##{n}" }
end

##
# Contexts
##

FactoryGirl.define :site do |f|
  f.sequence(:name) { |n| "Site##{n}" }
  f.sequence(:domain) { |n| "site#{n}.local" }
end
