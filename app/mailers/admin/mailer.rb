class Admin::Mailer < ActionMailer::Base

  def reset_password_instructions(user, host)
    @user = user
    @token_url = admin_account_url(user.token, host: host)

    options = {
      from: Typus.mailer_sender,
      to: user.email,
      subject: I18n.t('typus.emails.password_reset.title', admin_title: Typus.admin_title)
    }

    mail(options) do |format|
      format.text
      format.html
    end
  end

end
