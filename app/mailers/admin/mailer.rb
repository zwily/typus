class Admin::Mailer < ActionMailer::Base

  default :from => Typus::Configuration.options[:email]

  def reset_password_link(user, url)
    @user = user
    @url = url
    mail :to => user.email, 
         :subject => "[#{Typus::Configuration.options[:app_name]}] #{_("Reset password")}"
  end

end
