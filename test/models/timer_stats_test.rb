require "test_helper"

describe TimerStats do
  describe "completed_counts_at" do
    before do
      @today = Time.mktime(2015, 1, 1, 15, 0, 0)
    end

    it "returns 0 if there's no completed timer" do
      Timer.create(start_time: 5.minutes.ago, end_time: nil)
      assert_equal 0, TimerStats.new.completed_counts_on(@today)
    end

    it "returns 1 if there's one completed timer" do
      Timer.create(start_time: @today - 30.minutes, end_time: @today)
      assert_equal 1, TimerStats.new.completed_counts_on(@today.to_date)
    end
  end

  describe "last_completed_timer" do
    before do
      Timer.delete_all
    end

    it "returns last completed timer" do
      _older_timer =
        Timer.create(start_time: 40.minutes.ago, end_time: 15.minutes.ago)
      newer_timer =
        Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)

      assert_equal newer_timer, TimerStats.new.last_completed_timer
    end

    it "returns nil if there's no completed timer" do
      Timer.create(start_time: 5.minutes.ago, end_time: nil)
      assert_equal nil, TimerStats.new.last_completed_timer
    end
  end
end
