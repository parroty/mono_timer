class TimeOverlapValidator < ActiveModel::Validator
  MESSAGE = "Start Time should be earlier than End Time"

  def validate(record)
    if record.start_time == nil && record.end_time != nil
      record.errors.add :base, MESSAGE
      return
    end

    if record.start_time != nil && record.end_time != nil
      if record.start_time > record.end_time
        record.errors.add :base, MESSAGE
      end
    end
  end
end
