class TimeOverlapValidator < ActiveModel::Validator
  MESSAGE = "Start Time should be earlier than End Time"

  def validate(record)
    return if record.end_time.nil?

    if record.start_time.nil? || record.start_time > record.end_time
      record.errors.add :base, MESSAGE
    end
  end
end
