require "test_helper"

describe "timer display feature", :capybara do
  describe "when there's no timer" do
    before do
      Timer.delete_all
    end

    it "displays 1500 seconds (25:00)" do
      visit "/timers"
      assert_content "25:00"
      assert_match js_for_remaining_time(1500), page.body
    end

    it "shows timer history page" do
      visit "/timers/history"
      assert_content page, "Timer History"
    end
  end

  describe "when there's timer" do
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
