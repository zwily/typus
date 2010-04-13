require "test/test_helper"
require "app/mailers/admin/mailer"

class Admin::MailerTest < ActiveSupport::TestCase

  def setup
    @user = typus_users(:admin)
    url = "http://test.host/admin/reset_password?token=#{@user.token}"
    @response = Admin::Mailer.reset_password_link(@user, url).deliver
  end

=begin

  def test_should_verify_email_from_is_defined_by_typus_options
    assert_equal Typus::Configuration.email, @response.from
  end

=end

  def test_should_verify_email_to_is_typus_user_email
    assert_equal [ @user.email ], @response.to
  end

  def test_should_verify_email_subject
    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, @response.subject
  end

=begin

  def test_should_verify_email_contains_reset_password_link_with_token
    expected = "http://test.host/admin/reset_password?token=1A2B3C4D5E6F"
    assert_match expected, @response.body
  end

=end

end
