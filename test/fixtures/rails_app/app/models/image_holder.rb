=begin

  This model is used to test polymorphic associations.

=end

class ImageHolder < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :imageable, :polymorphic => true
end
