class Admin::Mailer < ActionMailer::Base

  default :from => Typus.email

  def reset_password_link(user, url)
    @user = user
    @url = url
    mail :to => user.email, 
         :subject => "[#{Typus.admin_title}] #{_("Reset password")}"
  end

end
