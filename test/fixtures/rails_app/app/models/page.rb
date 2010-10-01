class Page < ActiveRecord::Base

  acts_as_tree

  STATUS = { "Pending" => "pending",
             "Published" => "published",
             "Not Published" => "unpublished" }

end
