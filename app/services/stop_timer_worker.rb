class StopTimerWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(timer_id, enable_notification = false)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds > 0
      fail "Timer(#{timer_id}) still has #{timer.remaining_seconds} seconds."
    else
      timer.stop!
      send_notification if enable_notification
    end
  end

  private

  def send_notification
    count = TimerStats.new.completed_counts_on(Time.zone.today)
    message = "#{count.ordinalize} timer of today completed."
    Notifier.execute(message)
  end
end
