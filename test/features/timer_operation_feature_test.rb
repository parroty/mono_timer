require "test_helper"

describe "timer operation feature", :capybara do
  before do
    Timer.all.delete_all
    Pause.all.delete_all
  end

  describe "Pause" do
    before do
      Timer.create(start_time: 5.minutes.ago, end_time: nil)
    end

    it "pauses timer returns not counting-down timer" do
      visit '/timer'
      click_button('Pause')

      assert_equal 1, Pause.count
      assert page.has_content?("20:00")
      assert_match js_for_timer_state(counting_down: false), page.body
    end
  end

  describe "Resume" do
    before do
      timer = Timer.create!(start_time: 5.minutes.ago, end_time: nil)
      timer.pauses.create!(start_time: 1.minutes.ago, end_time: nil)
    end

    it "fills in end_time of pause" do
      visit '/timer'
      click_button('Resume')

      assert_equal 1, Timer.active.count
      assert_not_equal nil, Pause.last.end_time
    end
  end

  describe "Start" do
    it "creates timer and still shows the index page" do
      visit '/timer'
      click_button('Start')

      assert_equal 1, Timer.active.count
      assert_equal timer_index_path, current_path
    end
  end
end
