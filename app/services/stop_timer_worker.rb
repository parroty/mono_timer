class StopTimerWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(timer_id, send_notification = false)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds > 0
      raise "Timer(#{timer_id}) still has #{timer.remaining_seconds} seconds."
    else
      timer.stop!
      PushoverNotifier.new.notify("Timer #{timer_id} completed.") if send_notification
    end
  end
end
