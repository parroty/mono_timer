class StopTimerService
  def self.create(timer)
    StopTimerWorker.perform_in(timer.remaining_seconds, timer.id, true)
  end

  def self.destroy(timer)
    Sidekiq::ScheduledSet.new.each do |entry|
      entry.delete if fetch_timer_id(entry) == timer.id
    end
  end

  private

  def self.fetch_timer_id(entry)
    entry.item["args"].first.to_i
  end
end
