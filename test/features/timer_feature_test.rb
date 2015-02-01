require "test_helper"

class TimerFeatureTest < Capybara::Rails::TestCase
  setup do
    Timer.create!(start_time: DateTime.now, status: Timer::STATUS_ACTIVE, category: "Programming")
  end

  test "root page redirects to timer#index page" do
    visit '/'
  end

  test "gets timer index page" do
    visit '/timer'
    assert_content page, "Mono Timer"
  end

  test "gets timer list page" do
    visit '/timer/list'
    assert_content page, "Programming"
  end

  test "gets new timer page" do
    visit '/timer/new'
    assert_content page, "New Timer"
  end
end
