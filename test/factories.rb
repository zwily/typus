Factory.define :typus_user do |f|
  f.first_name "Admin"
  f.last_name "Example"
  f.role "admin"
  f.email "admin@example.com"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.salt "admin"
  f.crypted_password Digest::SHA1.hexdigest("--admin--12345678--")
  f.preferences Hash.new({ :locale => :en })
end

Factory.define :category do |f|
  name "Category"
end
