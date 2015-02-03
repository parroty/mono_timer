class TimerController < ApplicationController
  def index
    @timer = Timer.latest_timer
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

  def stop
    timer = Timer.find(params[:id])
    timer.update!(end_time: DateTime.now)
    redirect_to timer_index_path
  end
end
