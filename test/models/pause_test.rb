require "test_helper"

describe Pause do
  describe "validation" do
    it "shows an error on creating a end_time < start_time pause" do
      pause = Pause.create(start_time: 5.minutes.ago, end_time: 30.minutes.ago)
      assert_equal 1, pause.errors.size
    end

    it "shows an error on creating a end_time with nil_start_time timer" do
      timer = Timer.create(start_time: nil, end_time: 30.minutes.ago)
      assert_equal 1, timer.errors.size
    end

    it "doesn't show an error on creating a start_time < end_time pause" do
      pause = Pause.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)
      assert_equal 0, pause.errors.size
    end
  end

  describe "methods" do
    before do
      @timer =
        Timer.create(
          start_time: 10.minutes.ago, end_time: nil)
      @active_pause =
        @timer.pauses.create!(
          start_time: 5.minutes.ago, end_time: nil)
      @inactive_pause =
        @timer.pauses.create!(
          start_time: 5.minutes.ago, end_time: 3.minutes.ago)
    end

    describe "active?" do
      it "returns true for pause with no end_time" do
        assert_equal true, @active_pause.active?
      end

      it "returns false for pause with end_time" do
        assert_equal false, @inactive_pause.active?
      end
    end

    describe "complete" do
      it "changes the pause to non-active pause" do
        @active_pause.complete

        assert_equal false, @active_pause.active?
      end
    end

    describe "duration" do
      it "returns the pause duration in seconds" do
        assert_equal 2 * 60, @inactive_pause.duration
      end
    end
  end
end
