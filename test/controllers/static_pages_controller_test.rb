require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get Home" do
    get :Home
    assert_response :success
  end

  test "should get Products" do
    get :Products
    assert_response :success
  end

  test "should get FAQ" do
    get :FAQ
    assert_response :success
  end

  test "should get Forums" do
    get :Forums
    assert_response :success
  end

  test "should get Reviews" do
    get :Reviews
    assert_response :success
  end

  test "should get Support" do
    get :Support
    assert_response :success
  end

  test "should get Order" do
    get :Order
    assert_response :success
  end

end
