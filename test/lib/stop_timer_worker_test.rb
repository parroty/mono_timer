require 'test_helper'

class StopTimerWorkerTest < ActiveSupport::TestCase
  setup do
    StopTimerWorker.jobs.clear
    @timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
  end

  test "successfully create job" do
    assert_equal 0, StopTimerWorker.jobs.size
    StopTimerWorker.perform_async(@timer.id)
    assert_equal 1, StopTimerWorker.jobs.size
  end
end
