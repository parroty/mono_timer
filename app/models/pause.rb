require "#{Rails.root}/app/validators/time_overwrap_validator"

class Pause < ActiveRecord::Base
  belongs_to :timer, counter_cache: true

  validates_with ::TimeOverlapValidator

  def active?
    end_time.nil?
  end

  def complete
    update!(end_time: Time.zone.now) unless end_time
  end

  def duration
    ((end_time || Time.zone.now) - start_time).to_i
  end
end
