require File.dirname(__FILE__) + '/../test_helper'

class TypusUserTest < ActiveSupport::TestCase

  def test_check_email_format
    data = { :email => 'admin' }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:email)
  end

  def test_should_verify_email_is_unique
    create_typus_user
    typus_user = create_typus_user
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:email)
  end

  def test_should_verify_typus_user_has_first_name_and_last_name
    data = { :first_name => "", :last_name => "" }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:first_name)
    assert typus_user.errors.invalid?(:last_name)
  end

  def test_should_verify_lenght_of_password
    data = { :password => "1234", :password_confirmation => "1234" }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:password)
    data = { :password => "1234567812345678123456781234567812345678123456781234567812345678", 
             :password_confirmation => "1234567812345678123456781234567812345678123456781234567812345678" }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:password)
  end

  def test_should_verify_confirmation_of_password
    data = { :password => "12345678", :password_confirmation => "87654321" }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:password)
  end

protected

  def create_typus_user(options = {})
    data = { :first_name => "Admin", :last_name => "Typus", 
             :email => "admin@typus.org", 
             :password => "12345678", :password_confirmation => "12345678", 
             :roles => "admin" }.merge(options)
    TypusUser.create(data)
  end

end