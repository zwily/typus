require "test_helper"

class Admin::BaseControllerTest < ActionController::TestCase

  test 'white_label' do
    base = Admin::BaseController.new
    assert base.respond_to?(:white_label)
  end

  test '#set_locale sets the admins locale if admin is present' do
    base = Admin::BaseController.new
    base.stubs(:admin_user).returns(mock(locale: 'ADMIN_LOCALE'))
    I18n.expects(:locale=).with('ADMIN_LOCALE')
    base.send(:set_locale)
  end

  test "#set_locale sets the default locale if no admin is present" do
    base = Admin::BaseController.new
    base.stubs(:admin_user).returns(nil)
    I18n.expects(:locale=).with(Typus.default_locale)
    base.send(:set_locale)
  end

end
