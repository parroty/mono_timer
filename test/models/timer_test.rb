require 'test_helper'

describe Timer do
  describe "validation" do
    it "has a error on creating a end_time < start_time timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: 30.minutes.ago)
      assert_equal 1, timer.errors.size
    end

    it "doesn't have error on creating a start_time < end_time timer" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      assert_equal 0, timer.errors.size
    end
  end

  describe "status" do
    describe "with no pause" do
      it "returns INITIAL status for timer with no start_time" do
        timer = Timer.create(start_time: nil, end_time: nil)
        assert_equal Timer::Status::INITIAL, timer.status
      end

      it "returns RUNNING status for timer with no end_time" do
        timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
        assert_equal Timer::Status::RUNNING, timer.status
      end

      it "returns COMPLETED status for timer with end_time" do
        timer = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
        assert_equal Timer::Status::COMPLETED, timer.status
      end
    end

    describe "with pause" do
      it "returns PAUSED status for timer with active pause" do
        timer = Timer.create(start_time: 10.minutes.ago, end_time: nil)
        pause = timer.pauses.create!(start_time: 5.minutes.ago, end_time: nil)

        assert_equal Timer::Status::PAUSED, timer.status
      end

      it "returns RUNNING status for timer with non-active pause" do
        timer = Timer.create(start_time: 10.minutes.ago, end_time: nil)
        pause = timer.pauses.create!(start_time: 5.minutes.ago, end_time: 3.minutes.ago)

        assert_equal Timer::Status::RUNNING, timer.status
      end
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
    it "changes active timer to COMPLETED status" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
      timer.stop!

      assert_equal Timer::Status::COMPLETED, timer.status
    end

    it "does not its status and end_time of already stopped timer" do
      original_end_time = 5.minutes.ago
      timer = Timer.create(start_time: 30.minutes.ago, end_time: original_end_time)
      timer.stop!

      assert_equal original_end_time, timer.end_time
      assert_equal Timer::Status::COMPLETED, timer.status
    end
  end

  describe "current_timer" do
    before do
      Timer.all.delete_all
    end

    it "returns active timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)

      assert_equal Timer::Status::RUNNING, timer.status
    end

    it "returns new timer if latest timer is completed" do
      timer_inactive = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      timer = Timer.current_timer

      assert_equal Timer::Status::INITIAL, timer.status
    end

    it "returns new timer if there's no timer" do
      timer = Timer.current_timer
      assert_equal Timer::Status::INITIAL, timer.status
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
      timer = Timer.create(start_time: @today - 30.minutes, end_time: @today)
      assert_equal 1, Timer.completed_counts_at(@today)
    end
  end
end
