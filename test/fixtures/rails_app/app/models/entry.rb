=begin

  This model is not enabled in typus but is used to test things things like:

    - Single Table Inheritance

=end

class Entry < ActiveRecord::Base

  ##
  # Macros
  #

  has_trash

  ##
  # Validations
  #

  validates :title, :presence => true

  ##
  # Associations
  #

  has_and_belongs_to_many :categories

  ##
  # Scopes
  #

  default_scope where(:deleted_at => nil)

end
