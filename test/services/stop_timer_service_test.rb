require "test_helper"

describe StopTimerService do
  before do
    @timer = Timer.create(start_time: 5.minutes.ago, end_time: nil)
  end

  describe "create" do
    it "invokes StopTimerWorker#perform_in with correct parameters" do
      expected_time = (25 - 5) * 60
      StopTimerWorker.expects(:perform_in).with(expected_time, @timer.id, true)

      StopTimerService.create(@timer)
    end
  end

  describe "destroy" do
    it "invokes delete for the entry in the Sidekiq::ScheduledSet" do
      entry = stub(item: { "args" => [@timer.id] })
      entry.expects(:delete)
      Sidekiq::ScheduledSet.expects(:new).returns([entry])

      StopTimerService.destroy(@timer)
    end
  end
end
