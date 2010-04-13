require "test/test_helper"
require "test/rails_app/app/controllers/admin/categories_controller"

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

=begin

  # FIXME

  def test_should_verify_form_partial_can_overwrited_by_model
    get :new
    partials = %w( categories#_form.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

=end

end
