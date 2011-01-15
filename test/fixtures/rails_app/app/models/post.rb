class Post < ActiveRecord::Base

  STATUS = { "Draft" => "draft",
             "Published" => "published",
             "Unpublished" => "unpublished" }

  validates_presence_of :title, :body

  belongs_to :favorite_comment, :class_name => "Comment"
  belongs_to :typus_user
  has_and_belongs_to_many :categories
  has_many :assets, :as => :resource, :dependent => :destroy
  has_many :comments
  has_many :views

end
