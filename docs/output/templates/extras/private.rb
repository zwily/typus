##
# There are plugins/gems which are only available to clients.
#

answer = ask("Do you have access to trunksapp.com? (yes/NO)").downcase
extras = (answer == "yes" || answer == "y") ? true : false

if extras
  plugin "typus_cms", :git => "git@trunksapp.com:fesplugas/typus_cms.git"
  generate "typus_cms_migration"
  plugin "typus_settings", :git => "git@trunksapp.com:fesplugas/typus_settings.git"
  generate "typus_settings_migration"
end
