Typus.setup do |config|

  # Application name.
  config.admin_title = "<%= options[:admin_title] %>"
  # config.admin_sub_title = ""

  # Authentication: none, http_basic, session
  # config.authentication = :session

  # Configure the e-mail address which will be shown in Admin::Mailer.
  # When this option is define Typus will allow admin users to recover 
  # lost passwords.
  # config.mailer_sender = "admin@example.com"

  # Define file attachment settings.
  # config.file_preview = :typus_preview
  # config.file_thumbnail = :typus_thumbnail

  # Define relationship table.
  # config.relationship = "typus_users"

  # Define username and password for http authentication
  # config.username = "admin"
  # config.password = "columbia"

  # Define the default root.
  # config.master_role = "admin"

  # Define user_class_name and user_fk.
  config.user_class_name = "<%= options[:user_class_name] %>"
  config.user_fk = "<%= options[:user_fk] %>"

end
