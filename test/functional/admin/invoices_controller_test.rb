require "test_helper"

=begin

  What's being tested here?

    - Invoice belongs_to Order

=end

class Admin::InvoicesControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

  context "Unrelate" do

    setup do
      @invoice = Factory(:invoice)
      @order = @invoice.order
    end

    should "work for unrelate Invoice from Order" do
      post :unrelate, { :id => @invoice.id, :resource => 'Order', :resource_id => @order.id }
      assert @order.reload.invoice.nil?
      assert_equal "Order successfully updated.", flash[:notice]
    end

  end

end
