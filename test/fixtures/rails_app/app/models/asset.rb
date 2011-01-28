=begin

  This model is used to test:

    - Dragonfly Attachments
    - Paperclip Attachments

=end

class Asset < ActiveRecord::Base

  # Dragonfly Attachment
  image_accessor :dragonfly
  image_accessor :dragonfly_required
  validates_presence_of :dragonfly_required

  validates_presence_of :caption

  # Paperclip Attachment
  has_attached_file :paperclip, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def original_file_name
  end

end
