class StopTimerWorker
  include Sidekiq::Worker

  def perform(timer_id)
    timer = Timer.find(timer_id)
    if timer.remaining_seconds > 0
      raise "Timer(#{timer_id} is still running"
    else
      timer.stop
      timer.save
    end
  end
end
