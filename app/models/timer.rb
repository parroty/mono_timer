class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60
  paginates_per 50

  scope :active, -> { where("end_time is NULL") }

  def self.latest_timer
    Timer.order("id desc").first || Timer.new(start_time: nil)
  end

  def self.stop_timer!(id)
    timer = Timer.find(id)
    timer.stop!
  end

  def self.completed_counts_at(date_or_time)
    Timer.where("DATE(end_time) = ?", date_or_time.to_date).count
  end

  def stop!
    update(end_time: DateTime.now) if counting_down?
  end

  def counting_down?
    start_time != nil && end_time == nil
  end

  def remaining_seconds
    if start_time != nil && end_time != nil
      0
    elsif start_time != nil && end_time == nil
      time_passed = ((end_time || Time.zone.now) - start_time).to_i
      [INITIAL_TIME - time_passed, 0].max
    else
      INITIAL_TIME
    end
  end
end
