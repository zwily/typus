class Admin::Mailer < ActionMailer::Base

  default from: Typus.mailer_sender

  def reset_password_instructions(user, host)
    @user = user
    @token_url = admin_account_url(user.token, host: host)

    options = {
      to: user.email,
      subject: I18n.t('typus.emails.password_reset.title', admin_title: Typus.admin_title)
    }

    mail(options) do |format|
      format.text
      format.html
    end
  end

end
