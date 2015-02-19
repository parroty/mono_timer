class TimersController < ApplicationController
  ERROR_MESSAGE = "Failed to change the timer status, as it has already been changed in the background."

  def index
    @timer = Timer.current_timer
    @stats = TimerStats.new
  end

  def create
    if new_timer = Timer.start
      StopTimerService.create(new_timer)
      redirect_to timers_path
    else
      redirect_to timers_path, flash: { error: "A timer have already been started." }
    end
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
    if timer.stop
      StopTimerService.destroy(timer)
      redirect_to timers_path
    else
      redirect_to timers_path, flash: { error: ERROR_MESSAGE }
    end
  end

  def pause
    if timer.pause
      StopTimerService.destroy(timer)
      redirect_to timers_path
    else
      redirect_to timers_path, flash: { error: ERROR_MESSAGE }
    end
  end

  def resume
    if timer.resume
      StopTimerService.create(timer)
      redirect_to timers_path
    else
      redirect_to timers_path, flash: { error: ERROR_MESSAGE }
    end
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
