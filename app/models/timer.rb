class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60
  paginates_per 50

  has_many :pauses, dependent: :destroy

  scope :active, -> { where("end_time is NULL") }

  def self.latest_timer
    Timer.order("id desc").first || Timer.new(start_time: nil)
  end

  def self.completed_counts_at(date_or_time)
    Timer.where("DATE(end_time) = ?", date_or_time.to_date).count
  end

  def stop!
    if not_completed?
      update!(end_time: Time.zone.now)
      complete_pauses
    end
  end

  def pause
    pauses.create!(start_time: Time.zone.now)
  end

  def resume
    complete_pauses
  end

  def complete_pauses
    pauses.each { |pause| pause.complete }
  end

  def counting_down?
    not_completed? && paused? == false
  end

  def paused?
    end_time == nil && pauses.any? { |pause| pause.active? }
  end

  def not_completed?
    start_time != nil && end_time == nil
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
end
