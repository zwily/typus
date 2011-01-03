require "test_helper"

class Admin::AssetsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @post = Factory(:post)
  end

  should "verify polymorphic relationship message" do
    get :new, { :back_to => "/admin/posts/#{@post.id}/edit",
                :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash', "Cancel adding a new Asset?"
  end

  should_eventually "create a polymorphic relationship" do
    asset = { :caption => "Caption",
              :dragonfly_uid => File.new("#{Rails.root}/config/database.yml"),
              :dragonfly_required_uid => File.new("#{Rails.root}/config/database.yml") }

    assert_difference('@post.assets.count') do
      post :create, { :asset => asset,
                      :back_to => "/admin/posts/edit/#{@post.id}",
                      :resource => @post.class.name,
                      :resource_id => @post.id }
    end

    assert_response :redirect
    assert_redirected_to '/admin/posts/edit/1'
    assert_equal "Asset successfully assigned to Post.", flash[:notice]
  end

  context "edit" do

    setup do
      @asset = Factory(:asset)
      @request.env['HTTP_REFERER'] = "/admin/assets/edit/#{@asset.id}"
    end

    should "verify there is a file link" do
      get :edit, { :id => @asset.id }
      assert_match /media/, @response.body
    end

    should "verify dragonfly can be removed" do
      get :edit, { :id => @asset.id }
      assert_match /Remove Dragonfly/, @response.body

      assert @asset.dragonfly_uid.present?

      get :detach, { :id => @asset.id, :attribute => "dragonfly" }
      assert_response :redirect
      assert_redirected_to "/admin/assets/edit/#{@asset.id}"
      assert_equal "Asset successfully updated.", flash[:notice]

      @asset.reload
      assert @asset.dragonfly_uid.blank?
    end

    should "verify dragonfly_required can not removed" do
      get :edit, { :id => @asset.id }
      assert_no_match /Remove required file/, @response.body

      get :detach, { :id => @asset.id, :attribute => "dragonfly_required" }
      assert_response :success

      @asset.reload
      assert @asset.dragonfly_required.present?
    end

    should "verify message on polymorphic relationship" do
      asset = Factory(:asset)

      get :edit, { :id => asset.id,
                   :back_to => "/admin/posts/#{@post.id}/edit",
                   :resource => @post.class.name, :resource_id => @post.id }

      assert_select 'body div#flash', "Cancel adding a new Asset?"
    end

  end

  should_eventually "return to back_to url" do
    asset = Factory(:asset)
    back_to = "#assets"

    post :update, { :id => asset.id,
                    :back_to => back_to,
                    :resource => @post.class.name,
                    :resource_id => @post.id }

    assert_response :redirect
    assert_redirected_to "/admin/assets"
    assert_equal "Asset successfully updated.", flash[:notice]
  end

end
