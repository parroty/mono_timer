require 'test_helper'

class TimerIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Timer.create!(start_time: DateTime.now, status: Timer::STATUS_ACTIVE, category: "Programming")
  end

  test "gets timer index page" do
    get "/timer"

    assert_equal 200, response.status
    assert_match "Mono Timer", response.body
  end

  test "gets timer list page" do
    get "/timer/list"

    assert_equal 200, response.status
    assert_match "Programming", response.body
  end
end
