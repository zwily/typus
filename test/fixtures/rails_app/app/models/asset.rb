class Asset < ActiveRecord::Base

  belongs_to :resource, :polymorphic => true

  image_accessor :file

  validates_presence_of :file

end
