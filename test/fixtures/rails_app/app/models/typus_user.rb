class TypusUser < ActiveRecord::Base

  ROLE = Typus::Configuration.roles.keys.sort
  LOCALE = Typus.locales

  enable_as_typus_user

  has_many :invoices

end
