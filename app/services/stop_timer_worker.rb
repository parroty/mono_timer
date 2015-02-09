class StopTimerWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(timer_id, send_notification = false)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds > 0
      raise "Timer(#{timer_id}) still has #{timer.remaining_seconds} seconds."
    else
      timer.stop!
      if send_notification
        count = Timer.completed_counts_at(Date.today) + 1
        PushoverNotifier.new.notify("#{count.ordinalize} timer of today completed.")
      end
    end
  end
end
