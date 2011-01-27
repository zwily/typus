class Animal < ActiveRecord::Base
  validates_presence_of :name

  has_many :image_holders, :as => :imageable
end
