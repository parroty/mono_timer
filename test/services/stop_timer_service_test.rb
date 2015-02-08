require 'test_helper'

class StopTimerServiceTest < ActiveSupport::TestCase
  setup do
    @timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
  end

  test "creation of stop timer succeeds" do
    StopTimerWorker.expects(:perform_in).with(25 * 60, @timer.id, true)
    StopTimerService.create(@timer.id)
  end

  test "destroy of stop timer succeeds" do
    # TODO: needs assertion with certain way of Sidekiq::ScheduledSet mocking.
    StopTimerService.destroy(@timer.id)
  end
end
