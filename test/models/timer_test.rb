require 'test_helper'

describe Timer do
  describe "counting_down?" do
    it "returns true for timer with no end_time" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      assert_equal true, timer.counting_down?
    end

    it "return false for timer with end_time" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      assert_equal false, timer.counting_down?
    end
  end

  describe "remaining_seconds" do
    it "returns remaining time for active timer within 25:00" do
      timer = Timer.create(start_time: 10.minutes.ago)
      assert_equal (25 - 10) * 60, timer.remaining_seconds
    end

    it "returns 0 remaining time for active timer before 25:00 ago" do
      timer = Timer.create(start_time: 1.hour.ago)
      assert_equal 0, timer.remaining_seconds
    end
  end

  describe "stop!" do
    it "stops active timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      timer.stop!

      assert_equal false, timer.reload.counting_down?
    end
  end

  describe "Timer.stop_timer" do
    it "stops active timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      Timer.stop_timer!(timer)

      assert_equal false, timer.reload.counting_down?
    end

    it "does not change the end_time of already stopped timer" do
      original_end_time = 5.minutes.ago
      timer = Timer.create(start_time: 30.minutes.ago, end_time: original_end_time)
      Timer.stop_timer!(timer)

      assert_equal original_end_time, timer.end_time
    end
  end

  describe "Timer.active" do
    before do
      Timer.all.delete_all
    end

    it "returns active timer only" do
      timer_inactive = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      timer_active   = Timer.create(start_time: 5.minutes.ago, end_time: nil)

      assert_equal [timer_active], Timer.active
    end
  end

  describe "Timer.latest_timer" do
    before do
      Timer.all.delete_all
    end

    it "returns active timer by skipping newer inactive timer" do
      timer_inactive = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      timer_active   = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      timer = Timer.latest_timer

      assert_equal timer_active, timer
    end

    it "returns blank timer if there's no timer" do
      timer = Timer.latest_timer
      assert_equal nil, timer.start_time
    end
  end

  describe "Timer.completed_counts_at" do
    before do
      @today = Time.mktime(2015, 1, 1, 15, 0, 0)
    end

    it "returns 0 if there's no completed timer" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: nil)
      assert_equal 0, Timer.completed_counts_at(@today)
    end

    it "returns 1 if there's one completed timer" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: @today)
      assert_equal 1, Timer.completed_counts_at(@today)
    end
  end
end
