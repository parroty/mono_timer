require "test_helper"

describe "timer", :capybara do
  describe "when there's no timer" do
    before do
      Timer.all.delete_all
    end

    it "displays 1500 seconds (25:00)" do
      visit '/timer'
      assert_content "25:00"
      assert_match "1500", page.body
    end

    it "creates timer and still shows the index page" do
      timer_count = Timer.count

      visit '/timer'
      click_button('Start')

      assert_equal timer_count + 1, Timer.count
      assert_equal timer_index_path, current_path
    end

    it "shows timer history page" do
      visit '/timer/history'
      assert_content page, "Timer History"
    end

    it "shows new timer page" do
      visit '/timer/new'
      assert_content page, "New Timer"
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
      visit '/timer'
      assert_content "15:00"
      assert_match "900", page.body
    end
  end
end
