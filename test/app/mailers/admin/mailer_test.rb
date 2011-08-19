require "test_helper"

class Admin::MailerTest < ActiveSupport::TestCase

  test "reset_password_instructions" do
    @typus_user = FactoryGirl.build(:typus_user, :token => "qswed3-64g3fb")
    @url = "http://test.host/admin/account/#{@typus_user.token}"
    @email = Admin::Mailer.reset_password_instructions(@typus_user, @url)

    assert_nil Admin::Mailer.default[:from]
    assert @email.to.include?(@typus_user.email)

    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, @email.subject
    assert_equal "multipart/alternative", @email.mime_type

    assert_match @url, @email.body.encoded
  end

end
