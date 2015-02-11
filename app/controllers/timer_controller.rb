class TimerController < ApplicationController
  def index
    @timer = Timer.latest_timer
  end

  def new
    @timer = Timer.new
  end

  def history
    @timers = Timer.page(params[:page]).order("id desc")
  end

  def create
    new_timer = Timer.create!(start_time: DateTime.now)
    StopTimerService.create(new_timer.id)
    redirect_to timer_index_path
  end

  def destroy
    timer.destroy!
    redirect_to timer_history_path
  end

  def stop
    Timer.stop_timer!(params[:id])
    StopTimerService.destroy(params[:id])
    redirect_to timer_index_path
  end

  def pause
    timer.pauses.create!(start_time: DateTime.now)
    redirect_to timer_index_path
  end

  def resume
    timer.pauses.each do |pause|
      pause.update!(end_time: DateTime.now)
    end
    redirect_to timer_index_path
  end

private
  def timer
    Timer.find(params[:id])
  end
end
