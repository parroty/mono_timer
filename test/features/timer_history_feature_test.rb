require "test_helper"

describe "timer history", :capybara do
  it "deletes timer record" do
    timer_count = Timer.count

    visit timers_history_path
    first(:button, "Destroy").click

    assert_equal timer_count - 1, Timer.count
    assert_equal timers_history_path, current_path
  end
end
