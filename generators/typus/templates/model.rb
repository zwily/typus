class <%= options[:user_class_name] %> < ActiveRecord::Base

  set_table_name "#{typus_users_table_name}"

  ROLE = Typus::Configuration.roles.keys.sort
  LANGUAGE = Typus.locales

  enable_as_typus_user

end
