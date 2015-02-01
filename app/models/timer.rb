class Timer < ActiveRecord::Base
  STATUS_ACTIVE = 0
  INITIAL_TIME = 25 * 60

  def active?
    end_time == nil
  end

  def remaining_seconds
    passed_time = (Time.zone.now - start_time).to_i
    [INITIAL_TIME - passed_time, 0].max
  end
end
