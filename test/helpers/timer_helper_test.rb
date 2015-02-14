require "test_helper"

describe TimerHelper do
  include TimerHelper

  describe "seconds_to_timer_str" do
    it "converts 754 seconds to 12:34" do
      assert_equal "12:34", seconds_to_timer_str(754)
    end

    it "converts 0 second with zero padding" do
      assert_equal "00:00", seconds_to_timer_str(0)
    end
  end

  describe "to_display_time" do
    it "returns converted time string" do
      time = Time.mktime(2011, 12, 24, 00, 00, 00)
      assert_equal "2011/12/24 00:00:00", to_display_time(time)
    end

    it "returns nil when nil is specified" do
      assert_equal nil, to_display_time(nil)
    end
  end
end
