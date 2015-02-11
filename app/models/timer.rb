class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60
  paginates_per 50

  has_many :pauses, dependent: :destroy

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
    update!(end_time: Time.zone.now) if counting_down?
  end

  def counting_down?
    not_completed? && has_active_pause? == false
  end

  def remaining_seconds
    if not_completed?
      passed    = ((end_time || Time.zone.now) - start_time).to_i
      paused    = pauses.reduce(0) { |acc, pause| acc + pause.duration }
      remaining = INITIAL_TIME - (passed - paused)

      [remaining, 0].max
    else
      INITIAL_TIME
    end
  end
private
  def not_completed?
    start_time != nil && end_time == nil
  end

  def has_active_pause?
    pauses.any? { |pause| pause.active? }
  end
end
