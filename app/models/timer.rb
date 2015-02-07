class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60

  scope :active, -> { where("end_time is NULL") }

  def self.latest_timer
    Timer.order("id desc").first || Timer.new(start_time: nil)
  end

  def self.stop_timer!(id)
    timer = Timer.find(id)
    timer.stop!
  end

  def stop!
    if counting_down?
      update(end_time: DateTime.now)
    end
  end

  def counting_down?
    start_time != nil && end_time == nil
  end

  def remaining_seconds
    if start_time != nil
      time_passed = ((end_time || Time.zone.now) - start_time).to_i
      [INITIAL_TIME - time_passed, 0].max
    else
      INITIAL_TIME
    end
  end
end
