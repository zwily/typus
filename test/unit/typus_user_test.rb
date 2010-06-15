require "test/test_helper"

class TypusUserTest < ActiveSupport::TestCase

  script = <<-RAW
this_is_chelm@example.com
<script>location.href="http://spammersite.com"</script>
  RAW

  [ script, 'admin', 'TEST@EXAMPLE.COM', 'test@example', 'test@example.c', 'testexample.com' ].each do |value|
    should_not allow_value(value).for(:email)
  end

  [ 'test+filter@example.com', 'test.filter@example.com', 'test@example.co.uk', 'test@example.es' ].each do |value|
    should allow_value(value).for(:email)
  end

  should validate_presence_of :role

  # Remove all fixtures ... this is to make it compatible with the old 
  # tests. Will remove it once everything is refactored with Shoulda and 
  # FactoryGirl.
  setup do
    TypusUser.delete_all
  end

=begin
  def test_should_verify_typus_user_attributes
    [ :first_name, :last_name, :email, :role, :salt, :crypted_password ].each do |attribute|
      assert TypusUser.instance_methods.map { |i| i.to_sym }.include?(attribute)
    end
  end
=end

=begin
  def test_should_verify_definition_on_instance_methods
    [ :is_root?, :authenticated? ].each do |instance_method|
      assert TypusUser.instance_methods.map { |i| i.to_sym }.include?(instance_method)
    end
  end
=end

=begin
  def test_should_verify_email_is_unique
    @typus_user.save
    @another_typus_user = TypusUser.new(@data)
    assert @another_typus_user.invalid?
    assert @another_typus_user.errors[:email].any?
  end
=end

=begin
  def test_should_verify_length_of_password_when_under_within
    @typus_user.password = '1234'
    @typus_user.password_confirmation = '1234'
    assert @typus_user.invalid?
    assert @typus_user.errors[:password].any?
  end
=end

=begin
  def test_should_verify_length_of_password_when_its_within_on_lower_limit
    @typus_user.password = '=' * 8
    @typus_user.password_confirmation = '=' * 8
    assert @typus_user.valid?
  end
=end

=begin
  def test_should_verify_length_of_password_when_its_within_on_upper_limit
    @typus_user.password = '=' * 40
    @typus_user.password_confirmation = '=' * 40
    assert @typus_user.valid?
  end
=end

=begin
  def test_should_verify_length_of_password_when_its_over_within
    @typus_user.password = '=' * 50
    @typus_user.password_confirmation = '=' * 50
    assert @typus_user.invalid?
    assert @typus_user.errors[:password].any?
  end
=end

=begin
  def test_should_verify_confirmation_of_password

    @typus_user.password = '12345678'
    @typus_user.password_confirmation = '87654321'
    assert @typus_user.invalid?
    assert @typus_user.errors[:password].any?

    @typus_user.password = '12345678'
    @typus_user.password_confirmation = ''
    assert @typus_user.invalid?
    assert @typus_user.errors[:password].any?

  end
=end

  should "return email when first_name and last_name are not set" do
    typus_user = Factory(:typus_user)
    assert_equal typus_user.email, typus_user.name
  end

  should "return name when first_name and last_name are set" do
    typus_user = Factory(:typus_user, :first_name => "John", :last_name => "Smith")
    assert_equal "John Smith", typus_user.name
  end

  should "verify admin is root" do
    typus_user = Factory(:typus_user)
    assert typus_user.is_root?
  end

  should "verify editor is not root" do
    typus_user = Factory(:typus_user, :role => "editor")
    assert typus_user.is_not_root?
  end

=begin
  def test_should_verify_authenticated
    typus_user = Factory(:typus_user)
    assert typus_user.authenticated?('12345678')
    assert !typus_user.authenticated?('87654321')
  end
=end

  should "verify salt never changes" do
    typus_user = Factory(:typus_user)

    salt = typus_user.salt
    crypted_password = typus_user.crypted_password

    typus_user.update_attributes :password => '11111111', :password_confirmation => '11111111'
    assert_equal salt, typus_user.salt
    assert_not_equal crypted_password, typus_user.crypted_password
  end

  should "verify generate" do
    assert TypusUser.respond_to?(:generate)
    assert TypusUser.generate(:email => 'demo@example.com', :password => 'XXXXXXXX').invalid?
    assert TypusUser.generate(:email => 'demo@example.com', :password => 'XXXXXXXX', :role => 'admin').valid?
  end

  should "verify can?" do
    assert TypusUser.instance_methods.map { |i| i.to_sym }.include?(:can?)
    typus_user = Factory(:typus_user)
    assert typus_user.can?('delete', TypusUser)
    assert typus_user.can?('delete', 'TypusUser')
    assert !typus_user.cannot?('delete', 'TypusUser')
  end

end
