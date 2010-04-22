require "test/test_helper"
require "app/mailers/admin/mailer"

class Admin::MailerTest < ActiveSupport::TestCase

  def setup
    @user = typus_users(:admin)
    url = "http://test.host/admin/account/#{@user.token}"
    @email = Admin::Mailer.reset_password_link(@user, url)
  end

  def test_should_verify_email_from_is_defined_by_typus_options
    assert Admin::Mailer.default[:from].nil?
  end

  def test_should_verify_email_to_is_typus_user_email
    assert_equal [@user.email], @email.to
  end

  def test_should_verify_email_subject
    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, @email.subject
  end

  def test_should_verify_email_mime_type
    assert_equal "text/plain", @email.mime_type
  end

  def test_should_verify_email_contains_reset_password_link_with_token
    expected = "http://test.host/admin/account/1A2B3C4D5E6F"
    assert_match expected, @email.body.encoded
  end

end
