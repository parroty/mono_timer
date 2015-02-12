class TimersController < ApplicationController
  def index
    @timer = Timer.current_timer
  end

  def create
    new_timer = Timer.create(start_time: Time.zone.now)
    StopTimerService.create(new_timer)
    redirect_to timers_path
  end

  def show
    respond_to do |format|
      format.json { render json: timer.to_json(methods: :remaining_seconds) }
      format.html { redirect_to timers_path }
    end
  end

  def history
    @timers = Timer.includes(:pauses).page(params[:page]).order("id desc")
  end

  def stop
    timer.stop!
    StopTimerService.destroy(timer)
    redirect_to timers_path
  end

  def pause
    timer.pause
    StopTimerService.destroy(timer)
    redirect_to timers_path
  end

  def resume
    timer.resume
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
