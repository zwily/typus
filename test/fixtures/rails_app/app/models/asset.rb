class Asset < ActiveRecord::Base

  belongs_to :resource, :polymorphic => true

  image_accessor :file

end
