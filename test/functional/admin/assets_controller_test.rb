require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test habtm, hm, polimorphism, relate and unrelate.
#
class Admin::AssetsControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
  end

  ##
  # A page has many assets, and the relationship is polymorphic.
  #
  def test_should_test_polymorphic_relationship

    ##
    # First we create an asset for a page.
    #

    page = pages(:published)
    assert_equal 2, page.assets.size

    get :new, { :back_to => "/admin/pages/#{page.id}/edit", :model => page.class.name, :model_id => page.id }
    assert_match /You're adding a new \"Asset\" to a model. Do you want to cancel it?/, @response.body

    post :create, { :back_to => "/admin/pages/#{page.id}/edit", :model => page.class.name, :model_id => page.id }
    assert_response :redirect
    assert_redirected_to '/admin/pages/1/edit'

    assert_equal 3, page.assets.size
    assert flash[:success]
    assert_equal "Asset successfully assigned to page.", flash[:success]

    ##
    # And after is created, we unrelate them.
    #

    @request.env["HTTP_REFERER"] = "/admin/pages/#{page.id}/edit"

    get :unrelate, { :id => page.assets.first.id, :model => page.class.name, :model_id => page.id }
    assert_response :redirect
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert flash[:success]
    assert_match "Asset removed from Page.", flash[:success]

  end

end