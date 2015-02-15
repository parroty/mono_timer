require "test_helper"

describe "timer operation feature", :capybara do
  before do
    Timecop.freeze(Time.now)
    Timer.delete_all
    Pause.delete_all
  end

  after do
    Timecop.return
  end

  describe "Pause" do
    before do
      Timer.create(start_time: 5.minutes.ago, end_time: nil)
    end

    it "pauses timer returns not counting-down timer" do
      visit "/timers"
      click_button("Pause")

      assert_equal 1, Pause.count
      assert page.has_content?("20:00")
      assert_match js_for_timer_state(counting_down: false), page.body
    end
  end

  describe "Resume" do
    before do
      timer = Timer.create!(start_time: 10.minutes.ago, end_time: nil)
      timer.pauses.create!(start_time: 9.minutes.ago, end_time: nil)
    end

    it "resumes the pause for the timer and subtract the duration" do
      visit "/timers"
      click_button("Resume")

      assert_equal Timer::Status::RUNNING, Timer.current_timer.status
      assert_not_equal nil, Pause.last.end_time
      # should have 25 - (10 - 9) = 24 minutes remaining
      assert_match "24:00", find("div.timer-time").text
    end
  end

  describe "Start" do
    it "creates timer and still shows the index page" do
      visit "/timers"
      click_button("Start")

      assert_equal Timer::Status::RUNNING, Timer.current_timer.status
      assert_equal timers_path, current_path
    end
  end
end
