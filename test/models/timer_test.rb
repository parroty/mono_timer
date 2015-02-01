require 'test_helper'

class TimerTest < ActiveSupport::TestCase
  test "timer with no end_time is taken as active timer" do
    timer = Timer.create(end_time: nil)
    assert_equal true, timer.active?
  end

  test "timer with end_time is taken as non active timer" do
    timer = Timer.create(end_time: 30.minutes.ago)
    assert_equal false, timer.active?
  end

  test "active timer within 25:00 returns remaining time" do
    timer = Timer.create(start_time: 10.minutes.ago)
    assert_equal (25 - 10) * 60, timer.remaining_seconds
  end

  test "active timer before 25:00 ago returns 0" do
    timer = Timer.create(start_time: 1.hour.ago)
    assert_equal 0, timer.remaining_seconds
  end
end
