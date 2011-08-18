unless Rails.env.test?
  email_settings = YAML::load_file("config/email.yml")
  ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
end
