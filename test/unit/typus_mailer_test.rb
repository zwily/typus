require File.dirname(__FILE__) + '/../test_helper'

class TypusMailerTest < ActiveSupport::TestCase

  def setup
    @user = typus_users(:admin)
    ActionMailer::Base.default_url_options[:host] = 'http://test.host'
    @response = TypusMailer.deliver_reset_password_link(@user)
  end

  def test_should_check_email_contains_application_name_on_subject_and_body
    assert_match /#{Typus::Configuration.options[:app_name]}/, @response.subject
    assert_match /#{Typus::Configuration.options[:app_name]}/, @response.body
  end

  def test_should_verify_email_contains_token
    assert_match /#{@user.token}/, @response.body
  end

  def test_should_check_email_contains_user_full_name
    assert_match /#{@user.full_name}/, @response.body
  end

  def test_should_check_email_contains_signature
    assert_match /--\n#{Typus::Configuration.options[:app_name]}/, @response.body
 end

end
