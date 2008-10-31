require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test habtm, hm, polimorphism, relate and unrelate.
#
class Admin::PagesControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
  end

  ##
  # A page has many assets, and the relationship is polymorphic.
  #
  def test_should_create_a_poliymorphic_assets_for_a_page
    page = pages(:published)
    assert_equal 2, page.assets.size
    #get new_admin_asset_url
    # (:back_to => "/admin/pages/#{page.id}/edit&model=Page&model_id=#{page.id}")
    
    asset = assets(:first)
    assert asset.kind_of?(Asset)

    # get :controller => "admin/posts", :action => 'new'
    # get new_admin_typus_user_url
    

    #assert_response :success
#    assert_redirected_to
#    assert flash[:notice]
#    assert flash[:error]
#    assert flash[:warning]
  end

end