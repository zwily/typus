# Be sure to restart your server when you modify this file.

Typus::Configuration.setup do |config|
  config.app_name = 'rails3_typus'
  config.user_class_name = 'TypusUser'
  config.user_fk = 'typus_user_id'
  config.config_folder = '../../../../config/working'
end
