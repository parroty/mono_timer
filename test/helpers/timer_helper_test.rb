require 'test_helper'

class TimerHelperTest < ActionView::TestCase
  include TimerHelper

  test "754 seconds is convered to 12:34" do
    assert_equal "12:34", seconds_to_timer_str(754)
  end

  test "0 second is convered with zero padding" do
    assert_equal "00:00", seconds_to_timer_str(0)
  end

  test "formatting normal time works" do
    time = Time.mktime(2011, 12, 24, 00, 00, 00)
    assert_equal "2011/12/24 00:00:00", to_display_time(time)
  end

  test "formatting nil just returns nil" do
    assert_equal nil, to_display_time(nil)
  end
end
