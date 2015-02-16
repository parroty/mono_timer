require "#{Rails.root}/app/validators/time_overwrap_validator"

class Timer < ActiveRecord::Base
  INITIAL_TIME = 25 * 60

  class Status
    include Ruby::Enum

    define :INITIAL,   "INITIAL"
    define :RUNNING,   "RUNNING"
    define :PAUSED,    "PAUSED"
    define :COMPLETED, "COMPLETED"
  end

  paginates_per 50

  has_many :pauses, dependent: :destroy

  validates_with ::TimeOverlapValidator

  class << self
    def current_timer
      timer = Timer.order("id desc").first
      if timer.nil? || timer.status == Status::COMPLETED
        Timer.new
      else
        timer
      end
    end
  end

  def active?
    [Status::RUNNING, Status::PAUSED].include?(status)
  end

  def stop!
    return unless end_time.nil?

    update!(end_time: Time.zone.now)
    finish_pauses
  end

  def pause
    pauses.create!(start_time: Time.zone.now)
  end

  def resume
    finish_pauses
  end

  def status
    if start_time.nil?
      Status::INITIAL
    else
      if !end_time.nil?
        Status::COMPLETED
      else
        paused? ? Status::PAUSED : Status::RUNNING
      end
    end
  end

  def passed_seconds
    ((end_time || Time.zone.now) - start_time).to_i
  end

  def remaining_seconds
    case status
    when Status::INITIAL   then INITIAL_TIME
    when Status::RUNNING   then calculate_remaining_seconds
    when Status::PAUSED    then calculate_remaining_seconds
    when Status::COMPLETED then 0
    end
  end

  private

  def calculate_remaining_seconds
    paused    = pauses.reduce(0) { |a, e| a + e.duration }
    remaining = INITIAL_TIME - (passed_seconds - paused)

    [remaining, 0].max
  end

  def finish_pauses
    pauses.each(&:complete)
  end

  def paused?
    pauses.any?(&:active?)
  end
end
