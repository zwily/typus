require "test_helper"

class Admin::MailerTest < ActiveSupport::TestCase

  test 'reset_password_instructions' do
    host = 'example.com'
    user = typus_users(:admin)
    mail = Admin::Mailer.reset_password_instructions(user, host)

    assert mail.to.include?(user.email)

    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, mail.subject
    assert_equal 'multipart/alternative', mail.mime_type

    url = "http://#{host}/admin/account/#{user.token}"
    assert_match url, mail.body.encoded
  end

end
