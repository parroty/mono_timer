class TimerController < ApplicationController
  def index
    @timer = Timer.latest_timer
  end

  def new
    @timer = Timer.new
  end

  def history
    @timers = Timer.order(:id).reverse
  end

  def create
    timer = Timer.create!(start_time: DateTime.now)
    StopTimerWorker.perform_in(Timer::INITIAL_TIME, timer.id, true)
    redirect_to timer_index_path
  end

  def destroy
    Timer.find(params[:id]).destroy!
    redirect_to timer_history_path
  end

  def stop
    Timer.stop_timer!(params[:id])
    redirect_to timer_index_path
  end
end
