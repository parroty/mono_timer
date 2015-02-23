require "test_helper"

describe TimerStats do
  before do
    Timer.delete_all
  end

  describe "completed_counts_at" do
    before do
      Timecop.freeze(Time.zone.now.beginning_of_day + 1.hour)
    end

    after do
      Timecop.return
    end

    it "returns 0 if there's no completed timer" do
      FactoryGirl.create(:running)
      assert_equal 0, TimerStats.new.completed_counts_on(Time.zone.today)
    end

    it "returns 1 if there's one completed timer" do
      FactoryGirl.create(:completed)
      assert_equal 1, TimerStats.new.completed_counts_on(Time.zone.today)
    end
  end

  describe "last_completed_timer" do
    it "returns last completed timer" do
      _older_timer =
        Timer.create(start_time: 40.minutes.ago, end_time: 15.minutes.ago)
      newer_timer =
        Timer.create(start_time: 30.minutes.ago, end_time: 5.minutes.ago)

      assert_equal newer_timer, TimerStats.new.last_completed_timer
    end

    it "returns nil if there's only non-completed timer" do
      FactoryGirl.create(:running)
      assert_equal nil, TimerStats.new.last_completed_timer
    end
  end
end
