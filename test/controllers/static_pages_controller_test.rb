require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get Home" do
    get :home
    assert_response :success
  end

  test "should get Products" do
    get :products
    assert_response :success
  end

  test "should get Forums" do
    get :forums
    assert_response :success
  end

  test "should get Reviews" do
    get :reviews
    assert_response :success
  end

  test "should get Support" do
    get :support
    assert_response :success
  end

  test "should get Order" do
    get :cart
    assert_response :success
  end

end
