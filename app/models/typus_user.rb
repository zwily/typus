class TypusUser < ActiveRecord::Base

  set_table_name "typus_users"

  ROLE = Typus::Configuration.roles.keys.sort
  LANGUAGE = Typus.locales

  enable_as_typus_user

end
