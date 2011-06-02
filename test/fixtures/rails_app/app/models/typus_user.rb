class TypusUser < ActiveRecord::Base

  ##
  # Mixins
  #

  enable_as_typus_user

  ##
  # Associations
  #

  has_many :invoices

end
