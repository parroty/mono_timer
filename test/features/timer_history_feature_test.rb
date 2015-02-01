require "test_helper"

class TimerHistoryFeatureTest < Capybara::Rails::TestCase
  test "delete button in the history page deletes the timer record" do
    timer_count = Timer.count

    visit timer_history_path
    first(:button, 'Destroy').click

    assert_equal timer_count - 1, Timer.count
    assert_equal timer_history_path, current_path
  end
end
