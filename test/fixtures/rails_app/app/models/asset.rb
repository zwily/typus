class Asset < ActiveRecord::Base

  belongs_to :resource, :polymorphic => true

  # Dragonfly Attachment
  image_accessor :dragonfly
  image_accessor :dragonfly_required
  validates_presence_of :dragonfly_required

  # Paperclip Attachment
  has_attached_file :paperclip, :styles => { :medium => "300x300>", :thumb => "100x100>" }

end
