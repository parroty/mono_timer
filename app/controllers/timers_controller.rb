class TimersController < ApplicationController
  def index
    @timer = Timer.latest_timer
  end

  def history
    @timers = Timer.includes(:pauses).page(params[:page]).order("id desc")
  end

  def create
    new_timer = Timer.create!(start_time: Time.zone.now)
    StopTimerService.create(new_timer)
    redirect_to timers_path
  end

  def stop
    Timer.stop_timer!(timer)
    StopTimerService.destroy(timer)
    redirect_to timers_path
  end

  def pause
    timer.pauses.create!(start_time: Time.zone.now)
    StopTimerService.destroy(timer)
    redirect_to timers_path
  end

  def resume
    timer.pauses.each { |pause| pause.complete }
    StopTimerService.create(timer)
    redirect_to timers_path
  end

  def destroy
    timer.destroy!
    redirect_to timers_history_path
  end
private
  def timer
    @timer ||= Timer.find(params[:id])
  end
end
