class TimerController < ApplicationController
  def index
    timer = Timer.where("end_time IS NULL").first
    @remaining_time = timer.try(:remaining_seconds) || Timer::INITIAL_TIME
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
