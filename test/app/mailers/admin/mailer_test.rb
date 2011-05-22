require "test_helper"

class Admin::MailerTest < ActiveSupport::TestCase

  test "reset_password_link" do
    @typus_user = Factory.build(:typus_user, :token => "qswed3-64g3fb")
    @url = "http://test.host/admin/account/#{@typus_user.token}"
    @email = Admin::Mailer.reset_password_link(@typus_user, @url)

    assert_nil Admin::Mailer.default[:from]
    assert @email.to.include?(@typus_user.email)

    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, @email.subject
    assert_equal "text/plain", @email.mime_type

    assert_match @url, @email.body.encoded
  end

end
