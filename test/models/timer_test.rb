require "test_helper"

describe Timer do
  describe "validation" do
    it "shows an error on creating a end_time < start_time timer" do
      timer = Timer.create(start_time: 5.minutes.ago, end_time: 30.minutes.ago)
      assert_equal 1, timer.errors.size
    end

    it "shows an error on creating a end_time with nil_start_time timer" do
      timer = Timer.create(start_time: nil, end_time: 30.minutes.ago)
      assert_equal 1, timer.errors.size
    end

    it "doesn't show an error on creating a start_time < end_time timer" do
      timer = Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      assert_equal 0, timer.errors.size
    end
  end

  describe "status" do
    describe "with no pause" do
      it "returns INITIAL status for timer with no start_time" do
        timer = FactoryGirl.create(:initial)
        assert_equal Timer::Status::INITIAL, timer.status
      end

      it "returns RUNNING status for timer with no end_time" do
        timer = FactoryGirl.create(:running)
        assert_equal Timer::Status::RUNNING, timer.status
      end

      it "returns COMPLETED status for timer with end_time" do
        timer = FactoryGirl.create(:completed)
        assert_equal Timer::Status::COMPLETED, timer.status
      end
    end

    describe "with pause" do
      it "returns PAUSED status for timer with active pause" do
        timer = Timer.create(start_time: 10.minutes.ago, end_time: nil)
        timer.pauses.create!(start_time: 5.minutes.ago, end_time: nil)

        assert_equal Timer::Status::PAUSED, timer.status
      end

      it "returns RUNNING status for timer with non-active pause" do
        timer = Timer.create(start_time: 10.minutes.ago, end_time: nil)
        timer.pauses.create!(
          start_time: 5.minutes.ago, end_time: 3.minutes.ago)

        assert_equal Timer::Status::RUNNING, timer.status
      end
    end
  end

  describe "passed_seconds" do
    it "returns passed seconds for active timer within 25:00" do
      timer = Timer.create(start_time: 10.minutes.ago)
      assert_equal 10 * 60, timer.passed_seconds
    end

    it "returns 0 for a timer with start_timer = nil" do
      timer = Timer.new
      assert_equal 0, timer.passed_seconds
    end
  end

  describe "remaining_seconds" do
    it "returns remaining time for active timer within 25:00" do
      timer = Timer.create(start_time: 10.minutes.ago)
      expected_seconds = (25 - 10) * 60
      assert_equal expected_seconds, timer.remaining_seconds
    end

    it "returns 0 remaining time for active timer before 25:00 ago" do
      timer = Timer.create(start_time: 30.minutes.ago)
      assert_equal 0, timer.remaining_seconds
    end

    it "returns 0 remaining time for completed timer" do
      timer = FactoryGirl.create(:completed)
      assert_equal 0, timer.remaining_seconds
    end
  end

  describe "stop" do
    it "changes PAUSED timer to COMPLETED status" do
      timer = FactoryGirl.create(:paused)
      timer.stop

      assert_equal Timer::Status::COMPLETED, timer.status
    end

    it "fails to change RUNNING timer to COMPLETED status" do
      timer = FactoryGirl.create(:running)
      timer.stop

      assert_equal Timer::Status::RUNNING, timer.status
    end

    it "does not change the status and end_time of already stopped timer" do
      timer = FactoryGirl.create(:completed)
      original_end_time = timer.end_time

      timer.stop

      assert_equal original_end_time, timer.end_time
      assert_equal Timer::Status::COMPLETED, timer.status
    end
  end

  describe "Timer.current_timer" do
    before do
      Timer.delete_all
    end

    it "returns active timer" do
      timer = FactoryGirl.create(:running)

      assert_equal Timer::Status::RUNNING, timer.status
    end

    it "returns new timer if latest timer is completed" do
      FactoryGirl.create(:completed)
      timer = Timer.current_timer

      assert_equal Timer::Status::INITIAL, timer.status
    end

    it "returns new timer if there's no timer" do
      timer = Timer.current_timer
      assert_equal Timer::Status::INITIAL, timer.status
    end
  end
end
