require File.dirname(__FILE__) + '/../test_helper'

class TypusUserTest < ActiveSupport::TestCase

  def test_should_verify_attributes
    assert TypusUser.instance_methods.include?('first_name')
    assert TypusUser.instance_methods.include?('last_name')
    assert TypusUser.instance_methods.include?('email')
    assert TypusUser.instance_methods.include?('roles')
    assert TypusUser.instance_methods.include?('salt')
    assert TypusUser.instance_methods.include?('crypted_password')
  end

  def test_should_verify_email_format

    data = { :email => 'admin' }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:email)

    email = <<-END
this_is_chelm@example.com
<script>location.href="http://spammersite.com"</script>
END
    data = { :email => email }
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

  def test_should_verify_length_of_password_when_under_within
    data = { :password => "1234", :password_confirmation => "1234" }
    typus_user = create_typus_user(data)
    assert !typus_user.valid?
    assert typus_user.errors.invalid?(:password)
  end

  def test_should_verify_length_of_password_when_its_within_on_lower_limit
    data = { :password => "=" * 8, 
             :password_confirmation => "=" * 8 }
    typus_user = create_typus_user(data)
    assert typus_user.valid?
  end

  def test_should_verify_length_of_password_when_its_within_on_upper_limit
    data = { :password => "=" * 40, 
             :password_confirmation => "=" * 40 }
    typus_user = create_typus_user(data)
    assert typus_user.valid?
  end

  def test_should_verify_length_of_password_when_its_over_within
    data = { :password => "=" * 50, 
             :password_confirmation => "=" * 50 }
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
    data = { :email => "test@example.com", 
             :password => "12345678", :password_confirmation => "12345678", 
             :roles => Typus::Configuration.options[:root] }.merge(options)
    TypusUser.create(data)
  end

end