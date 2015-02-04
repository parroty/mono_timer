class StopTimerWorker
  include Sidekiq::Worker

  def perform(timer_id)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds == 0
      timer.stop
      timer.save
    end
  end
end
