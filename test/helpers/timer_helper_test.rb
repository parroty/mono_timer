require 'test_helper'

class TimerHelperTest < ActionView::TestCase
  include TimerHelper

  test "754 seconds is convered to 12:34" do
    assert_equal "12:34", seconds_to_timer_str(754)
  end

  test "0 second is convered with zero padding" do
    assert_equal "00:00", seconds_to_timer_str(0)
  end
end
