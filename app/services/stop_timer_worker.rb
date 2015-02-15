class StopTimerWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(timer_id, notification_mode = false)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds > 0
      fail "Timer(#{timer_id}) still has #{timer.remaining_seconds} seconds."
    else
      timer.stop!
      send_notification if notification_mode
    end
  end

  private

  def send_notification
    count = TimerStats.new.completed_counts_on(Date.today) + 1
    message = "#{count.ordinalize} timer of today completed."
    PushoverNotifier.new.notify(message)
  end
end
