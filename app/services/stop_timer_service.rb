class StopTimerService
  def self.create(timer_id)
    StopTimerWorker.perform_in(Timer::INITIAL_TIME, timer_id, true)
  end

  def self.destroy(timer_id)
    Sidekiq::ScheduledSet.new.each do |entry|
      entry.delete if fetch_timer_id(entry) == timer_id.to_i
    end
  end

  private

  def self.fetch_timer_id(entry)
    entry.item["args"].first.to_i
  end
end
