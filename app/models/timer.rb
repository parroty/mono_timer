class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60

  scope :active, -> { where("end_time is NULL") }

  def self.latest_timer
    Timer.active.order("id desc").first || Timer.new(start_time: nil)
  end

  def counting_down?
    start_time != nil && end_time == nil
  end

  def remaining_seconds
    if start_time != nil
      time_passed = (Time.zone.now - start_time).to_i
      [INITIAL_TIME - time_passed, 0].max
    else
      INITIAL_TIME
    end
  end
end
