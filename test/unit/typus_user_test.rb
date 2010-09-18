require "test_helper"

class TypusUserTest < ActiveSupport::TestCase

  [ %Q(this_is_chelm@example.com\n<script>location.href="http://spammersite.com"</script>),
    'admin', 'TEST@EXAMPLE.COM', 'test@example', 'test@example.c', 'testexample.com' ].each do |value|
    should_not allow_value(value).for(:email)
  end

  [ 'test+filter@example.com', 'test.filter@example.com', 'test@example.co.uk', 'test@example.es' ].each do |value|
    should allow_value(value).for(:email)
  end

  should validate_presence_of :role

  should_not allow_mass_assignment_of :status

  should ensure_length_of(:password).is_at_least(6).is_at_most(40)

  # should validate_uniqueness_of :email

  should "verify columns" do
    attributes = %w( id first_name last_name email role status salt crypted_password token preferences created_at updated_at )
    TypusUser.columns.collect { |u| u.name }.each { |c| assert attributes.include?(c) }
  end

  should "verify generate requires the role" do
    assert TypusUser.generate(:email => 'demo@example.com', :password => 'XXXXXXXX').valid?
    assert TypusUser.generate(:email => 'demo@example.com', :password => 'XXXXXXXX', :role => 'admin').valid?
  end

  context "TypusUser" do

    setup do
      @typus_user = Factory(:typus_user)
    end

    should "return email when first_name and last_name are not set" do
      assert_equal @typus_user.email, @typus_user.name
    end

    should "return name when first_name and last_name are set" do
      @typus_user.first_name, @typus_user.last_name = "John", "Lock"
      assert_equal "John Lock", @typus_user.name
    end

    should "verify salt never changes" do
      expected = @typus_user.salt
      @typus_user.update_attributes(:password => '11111111', :password_confirmation => '11111111')
      assert_equal expected, @typus_user.salt
    end

    should "verify authenticated? returns true when password is right" do
      assert @typus_user.authenticated?('12345678')
    end

    should "verify authenticated? returns false when password is wrong" do
      assert !@typus_user.authenticated?('87654321')
    end

    should "verify can? (with a model as a param)" do
      assert @typus_user.can?('delete', TypusUser)
    end

    should "verify can? (with a string as a param)" do
      assert @typus_user.can?('delete', 'TypusUser')
    end

    should "verify cannot?" do
      assert !@typus_user.cannot?('delete', 'TypusUser')
    end

  end

  context "Admin Role" do

    setup do
      @typus_user = Factory(:typus_user, :role => "admin")
    end

    should "respond true to is_root?" do
      assert @typus_user.is_root?
    end

    should "respond false to is_not_root?" do
      assert !@typus_user.is_not_root?
    end

  end

  context "Editor Role" do

    setup do
      @typus_user = Factory(:typus_user, :role => "editor")
    end

    should "respond true to is_no_root?" do
      assert @typus_user.is_not_root?
    end

    should "respond false to is_root?" do
      assert !@typus_user.is_root?
    end

  end

end
