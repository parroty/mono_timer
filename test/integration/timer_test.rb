require 'test_helper'

class TimerTest < ActionDispatch::IntegrationTest
  test "gets timer index page" do
    get "/timer"

    assert_equal 200, response.status
    assert_match "Mono Timer", response.body
  end
end
