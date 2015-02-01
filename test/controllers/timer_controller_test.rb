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

  test "gets timer history page succeeds" do
    get :history
    assert_response :success
    must_render_template :history
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

  test "delete timer succeeds and gets redirected to history page" do
    delete :destroy, id: @timer.id
    assert_redirected_to timer_history_path
  end
end
