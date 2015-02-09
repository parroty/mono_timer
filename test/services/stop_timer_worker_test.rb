require 'test_helper'

describe StopTimerWorker do
  before do
    StopTimerWorker.jobs.clear
  end

  describe "timer with no remaining time" do
    before do
      @timer = Timer.create(start_time: 30.minutes.ago, end_time: nil)
    end

    it "increments sidekiq job" do
      assert_equal 0, StopTimerWorker.jobs.size

      StopTimerWorker.perform_async(@timer.id)

      assert_equal 1, StopTimerWorker.jobs.size
    end

    it "stops timer and fills in end_time" do
      StopTimerWorker.new.perform(@timer.id)

      refute_nil @timer.reload.end_time
    end

    it "stops timer and send notification with send_notification = true option" do
      PushoverNotifier.any_instance.expects(:notify).with do |param|
        param =~ /timer of today completed/
      end

      StopTimerWorker.new.perform(@timer.id, true)
    end
  end

  describe "timer with remaining time" do
    before do
      @timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
    end

    describe "perform" do
      it "trying to stop timer with remaining time fails" do
        assert_raises RuntimeError do
          StopTimerWorker.new.perform(@timer.id)
        end
      end
    end
  end
end
