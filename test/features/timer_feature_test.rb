require "test_helper"

class TimerFeatureTest < Capybara::Rails::TestCase
  test "gets timer index page" do
    visit '/timer'
    assert_content page, "Mono Timer"
  end

  test "gets timer list page" do
    visit '/timer/list'
    assert_content page, "Timer List"
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
end
