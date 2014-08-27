=begin

  This model is used to test:

    - ActsAsList on resources_controller

=end

class Category < ActiveRecord::Base

  ##
  #
  #

  # attr_protected :permalink, :position, :as => :admin
  # attr_protected :permalink, :position

  ##
  # Mixins
  #

  acts_as_list
  permalink :name

  ##
  # Validations
  #

  validates :name, presence: true

  ##
  # Associations
  #

  has_and_belongs_to_many :entries
  has_and_belongs_to_many :posts

end
