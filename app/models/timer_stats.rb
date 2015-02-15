class TimerStats
  def last_completed_timer
    Timer.order("id desc").where("end_time is not null").first
  end

  def completed_counts_on(date)
    Timer.where(end_time: (date.beginning_of_day)..(date.end_of_day)).count
  end
end
