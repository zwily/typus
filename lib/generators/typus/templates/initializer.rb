Typus.setup do |config|

  # Application name.
  config.admin_title = "<%= options[:admin_title] %>"

  # Define this option to allow admin users to recover lost passwords.
  # config.email = 'admin@example.com'

  # Define file attachment settings.
  # config.file_preview = :typus_preview
  # config.file_thumbnail = :typus_thumbnail

  # Define relationship table.
  # config.relationship = "typus_users"

  # Define the default root.
  # config.master_role = "admin"

  # Define user_class_name and user_fk.
  config.user_class_name = "<%= options[:user_class_name] %>"
  config.user_fk = "<%= options[:user_fk] %>"

end

Typus::Resource.setup do |config|
  # config.default_action_on_item = "edit"
  # config.end_year = nil
  # config.form_rows = 15
  # config.action_after_save = :edit
  # config.minute_step = 5
  # config.nil = "nil"
  # config.on_header = false
  # config.only_user_items = false
  # config.per_page = 15
  # config.sidebar_selector = 5
  # config.start_year = nil
end
