require 'test_helper'

class StopTimerWorkerTest < ActiveSupport::TestCase
  setup do
    StopTimerWorker.jobs.clear
    @timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
  end

  test "successfully create job for async execution" do
    assert_equal 0, StopTimerWorker.jobs.size
    StopTimerWorker.perform_async(@timer.id)
    assert_equal 1, StopTimerWorker.jobs.size
  end

  test "successfully stop timer and send notification with 0 remaining time" do
    timer = Timer.create(start_time: 30.minutes.ago, end_time: nil)
    StopTimerWorker.new.perform(timer.id)
    assert_not_equal nil, timer.reload.end_time
  end

  test "trying to stop timer with remaining time fails" do
    assert_raises RuntimeError do
      StopTimerWorker.new.perform(@timer.id)
    end
  end

  test "sends notification if notification: true option is specified" do
    timer = Timer.create(start_time: 30.minutes.ago, end_time: nil)
    PushoverNotifier.any_instance.expects(:notify).with("Timer #{timer.id} completed.")

    StopTimerWorker.new.perform(timer.id, notification: true)
  end
end
