require 'test_helper'

class TimerControllerTest < ActionController::TestCase
  setup do
    Timer.create!(start_time: DateTime.now, status: Timer::STATUS_ACTIVE, category: "Programming")
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "gets timer list page" do
    get :list
    assert_response :success
  end

  test "gets new timer page" do
    get :new
    assert_response :success
  end
end
