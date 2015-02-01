class TimerController < ApplicationController
  def index
    timer = Timer.where("end_time IS NULL").first
    if timer == nil
      @remaining_time = "25:00"
    else
      time_diff = Time.zone.now - timer.start_time
      remaining = [25 * 60 - time_diff, 0].max

      minutes = (remaining / 60).floor
      seconds = remaining % 60
      @remaining_time = sprintf "%02d:%02d", minutes, seconds
    end
  end

  def new
    @timer = Timer.new
  end

  def history
    @timers = Timer.all
  end

  def create
    Timer.create!(start_time: DateTime.now)
    redirect_to timer_index_path
  end

  def destroy
    Timer.find(params[:id]).destroy!
    redirect_to timer_history_path
  end
end
