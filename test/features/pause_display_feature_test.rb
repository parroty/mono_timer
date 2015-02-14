require "test_helper"

describe "pause display feature", :capybara do
  before do
    @timer = Timer.create!(start_time: 10.minutes.ago, end_time: nil)
    @pause = @timer.pauses.create!(start_time: 5.minutes.ago, end_time: nil)
  end

  it "shows the list of pauses for the specified timer" do
    visit "/timers/#{@timer.id}/pauses"

    assert page.has_content?(@timer.id)
    assert page.has_content?(@pause.id)
  end
end
