require 'test_helper'

class TimerControllerTest < ActionController::TestCase
  setup do
    @timer = Timer.create!(start_time: DateTime.now, status: Timer::STATUS_ACTIVE, category: "Programming")
  end

  test "get index succeeds" do
    get :index
    assert_response :success
    must_render_template :index
  end

  test "gets timer list page succeeds" do
    get :list
    assert_response :success
    must_render_template :list
  end

  test "gets new timer page succeeds" do
    get :new
    assert_response :success
    must_render_template :new
  end

  test "create timer succeeds and gets redirected to index page" do
    post :create
    assert_redirected_to timer_index_path
  end

  test "delete timer succeeds and gets redirected to list page" do
    delete :destroy, id: @timer.id
    assert_redirected_to timer_list_path
  end
end
