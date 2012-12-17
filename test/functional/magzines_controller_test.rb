require 'test_helper'

class MagzinesControllerTest < ActionController::TestCase
  setup do
    @magzine = magzines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:magzines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create magzine" do
    assert_difference('Magzine.count') do
      post :create, magzine: @magzine.attributes
    end

    assert_redirected_to magzine_path(assigns(:magzine))
  end

  test "should show magzine" do
    get :show, id: @magzine.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @magzine.to_param
    assert_response :success
  end

  test "should update magzine" do
    put :update, id: @magzine.to_param, magzine: @magzine.attributes
    assert_redirected_to magzine_path(assigns(:magzine))
  end

  test "should destroy magzine" do
    assert_difference('Magzine.count', -1) do
      delete :destroy, id: @magzine.to_param
    end

    assert_redirected_to magzines_path
  end
end
