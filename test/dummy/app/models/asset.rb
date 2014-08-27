=begin

  This model is used to test:

    - Dragonfly Attachments
    - Paperclip Attachments

=end

class Asset < ActiveRecord::Base

  ##
  # Dragonfly Stuff
  #

  if defined?(Dragonfly)
    extend Dragonfly::Model
    extend Dragonfly::Model::Validations

    dragonfly_accessor :dragonfly
    dragonfly_accessor :dragonfly_required

    validates :dragonfly_required, presence: true
  end

  ##
  # Paperclip Stuff
  #

  if defined?(Paperclip)
    PAPERCLIP_STYLES = { medium: '300x300>', thumb: '100x100>' }

    has_attached_file :paperclip, styles: PAPERCLIP_STYLES

    has_attached_file :paperclip_required, styles: PAPERCLIP_STYLES
    validates_with AttachmentPresenceValidator, attributes: :paperclip_required

    # https://github.com/thoughtbot/paperclip#security-validations
    do_not_validate_attachment_file_type :paperclip, :paperclip_required
  end

  ##
  # Instance Methods
  #

  def original_file_name
  end

end
