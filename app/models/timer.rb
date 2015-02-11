class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60

  module Status
    INITIAL   = 1
    RUNNING   = 2
    PAUSED    = 3
    COMPLETED = 4
  end

  paginates_per 50

  has_many :pauses, dependent: :destroy

  scope :active, -> { where("end_time is NULL") }

  def self.latest_active_timer
    Timer.active.order("id desc").first
  end

  def self.completed_counts_at(date_or_time)
    Timer.where("DATE(end_time) = ?", date_or_time.to_date).count
  end

  def stop!
    if end_time == nil
      update!(end_time: Time.zone.now)
      finish_pauses
    end
  end

  def pause
    pauses.create!(start_time: Time.zone.now)
  end

  def resume
    finish_pauses
  end

  def status
    if start_time == nil
      Status::INITIAL
    else
      if end_time != nil
        Status::COMPLETED
      else
        if paused?
          Status::PAUSED
        else
          Status::RUNNING
        end
      end
    end
  end

  def passed_seconds
    ((end_time || Time.zone.now) - start_time).to_i
  end

  def remaining_seconds
    case status
    when Status::INITIAL then
      INITIAL_TIME
    when Status::RUNNING then
      calculate_remaining_seconds
    when Status::PAUSED then
      calculate_remaining_seconds
    when Status::COMPLETED then
      0
    else
      raise "Invalid status value: #{status}"
    end
  end

private

  def calculate_remaining_seconds
    paused    = pauses.reduce(0) { |acc, pause| acc + pause.duration }
    remaining = INITIAL_TIME - (passed_seconds - paused)

    [remaining, 0].max
  end

  def finish_pauses
    pauses.each { |pause| pause.complete }
  end

  def paused?
    pauses.any? { |pause| pause.active? }
  end
end
