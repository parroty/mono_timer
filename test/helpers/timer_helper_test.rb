require 'test_helper'

class TimerHelperTest < ActiveSupport::TestCase
  setup do
    class TestHelper < ActionView::Base
      include TimerHelper
    end
    @helper = TestHelper.new
  end

  test "754 seconds is convered to 12:34" do
    assert_equal "12:34", @helper.seconds_to_timer_str(754)
  end

  test "0 second is convered with zero padding" do
    assert_equal "00:00", @helper.seconds_to_timer_str(0)
  end
end
