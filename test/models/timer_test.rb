require 'test_helper'

module TimerTest
  class SingleTimerTest < ActiveSupport::TestCase
    setup do
      Timer.all.delete_all
    end

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

    test "stop! method fills in end_time" do
      timer = Timer.create(start_time: 1.hour.ago, end_time: nil)
      timer.stop!
      assert_not_equal nil, timer.reload.end_time
    end

    test "Timer.latest_timer returns blank timer if there's no active timer" do
      timer = Timer.latest_timer
      assert_equal nil, timer.start_time
    end

    test "Timer.stop_timer stops active timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      Timer.stop_timer!(timer.id)
      assert_equal false, timer.reload.counting_down?
    end

    test "Timer.stop_timer does not change the end_time of already stopped tiemr" do
      original_end_time = 5.minutes.ago
      timer = Timer.create(start_time: 30.minutes.ago, end_time: original_end_time)
      Timer.stop_timer!(timer.id)
      assert_equal original_end_time, timer.end_time
    end

    test "Timer.completed_counts_at returns 0 if there's no completed timer" do
      today = Time.zone.local(2015, 1, 1)
      timer = Timer.create(start_time: 30.minutes.ago, end_time: nil)
      assert_equal 0, Timer.completed_counts_at(today)
    end

    test "Timer.completed_counts_at returns 1 if there's one completed timer" do
      today = Time.mktime(2015, 1, 1, 15, 0, 0)
      timer = Timer.create(start_time: 30.minutes.ago, end_time: today)
      assert_equal 1, Timer.completed_counts_at(today)
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
