Factory.define :asset do |f|
  f.caption "Caption"
  f.resource_type Post
  f.resource_id 1
end

Factory.define :category do |f|
  f.name "Category"
end

Factory.define :comment do |f|
  f.name "John"
  f.email "john@example.com"
  f.body "Body of the comment"
  f.association :post

end

Factory.define :page do |f|
  f.title "Title"
  f.body "Content"
  f.status "published"
end

Factory.define :typus_user do |f|
  f.email "admin@example.com"
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
  f.preferences Hash.new({ :locale => :en })
end
