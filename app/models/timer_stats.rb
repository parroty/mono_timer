class TimerStats
  def last_completed_timer
    Timer.order("id desc").where("end_time is not null").first
  end

  def completed_counts_on(date)
    Timer.where("DATE(end_time) = ?", date).count
  end
end
