class Page < ActiveRecord::Base

  acts_as_tree if defined?(ActiveRecord::Acts::Tree)

  STATUS = { "pending" => "Pending", 
             "published" => "Published", 
             "unpublished" => "Not Published" }

end
