require "test_helper"

module TimerFeatureTest
  class WithActiveTimer < Capybara::Rails::TestCase
    test "timer index page has string for 1500 seconds (25:00)" do
      visit '/timer'
      assert_match "1500", page.body
    end
  end

  class WithNoActiveTimer < Capybara::Rails::TestCase
    setup do
      Timecop.freeze(Time.now)
      Timer.create!(start_time: 10.minutes.ago)
    end

    teardown do
      Timecop.return
    end

    test "timer index page shows remaining time string for 900 seconds (25:00 - 10:00 -> 15:00)" do
      visit '/timer'
      assert_match "900", page.body
    end
  end

  class TimerFeatureTest < Capybara::Rails::TestCase
    test "gets timer history page" do
      visit '/timer/history'
      assert_content page, "Timer History"
    end

    test "gets new timer page" do
      visit '/timer/new'
      assert_content page, "New Timer"
    end

    test "click Start button creates and increases the timer count and still shows the index page" do
      timer_count = Timer.count

      visit '/timer'
      click_button('Start')

      assert_equal timer_count + 1, Timer.count
      assert_equal timer_index_path, current_path
    end

    # test "click Stop button stops timer which fills in the stop_time" do
    # end
  end
end