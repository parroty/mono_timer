require "test_helper"

describe "timer display feature", :capybara do
  describe "when there's no timer" do
    before do
      Timer.delete_all
    end

    describe "index" do
      it "displays 1500 seconds (25:00)" do
        visit "/timers"
        assert_content "25:00"
        assert_match js_for_remaining_time(1500), page.body
      end

      it "does not show last completed time in the footer" do
        visit "/timers"
        assert_no_content "Last timer completed at"
      end
    end

    it "shows timer history page" do
      visit "/timers/history"
      assert_content page, "Timer History"
    end
  end

  describe "when there's completed timer" do
    before do
      FactoryGirl.create(:completed)
    end

    it "shows last completed time in the footer" do
      visit "/timers"
      assert_content "Last timer completed"
    end
  end

  describe "when there's non-completed timer" do
    before do
      Timecop.freeze(Time.now)
      Timer.create!(start_time: 10.minutes.ago)
    end

    after do
      Timecop.return
    end

    it "shows remaining time for 900 seconds (25:00 - 10:00 -> 15:00)" do
      visit "/timers"
      assert_content "15:00"
      assert_match js_for_remaining_time(900), page.body
    end
  end
end
