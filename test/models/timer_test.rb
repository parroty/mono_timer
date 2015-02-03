require 'test_helper'

module TimerTest
  class SingleTimerTest < ActiveSupport::TestCase
    test "timer with no end_time is taken as active timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      assert_equal true, timer.counting_down?
    end

    test "timer with end_time is taken as non-active timer" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      assert_equal false, timer.counting_down?
    end

    test "active timer within 25:00 returns remaining time" do
      timer = Timer.create(start_time: 10.minutes.ago)
      assert_equal (25 - 10) * 60, timer.remaining_seconds
    end

    test "active timer before 25:00 ago returns 0" do
      timer = Timer.create(start_time: 1.hour.ago)
      assert_equal 0, timer.remaining_seconds
    end

    test "Timer.latest_timer returns blank timer if there's no active timer" do
      timer = Timer.latest_timer
      assert_equal nil, timer.start_time
    end
  end

  class MixtureTimerTest < ActiveSupport::TestCase
    setup do
      @timer_inactive = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      @timer_active   = Timer.create(start_time: 5.minutes.ago, end_time: nil)
    end

    test "Timer.active returns active timer only" do
      assert_equal [@timer_active], Timer.active
    end

    test "Timer.latest_timer returns active timer" do
      timer = Timer.latest_timer
      assert_equal @timer_active, timer
    end
  end
end
