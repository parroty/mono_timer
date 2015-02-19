class TimersController < ApplicationController
  ERROR_MESSAGE =
    "Failed to change the timer status, as it has already been changed " \
    "in the background."

  def index
    @timer = Timer.current_timer
    @stats = TimerStats.new
  end

  def create
    if (new_timer = Timer.start)
      StopTimerService.create(new_timer)
      redirect_to timers_path
    else
      message = "A timer have already been started."
      redirect_to timers_path, flash: { error: message }
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
    change_timer_status(:stop, :destroy)
  end

  def pause
    change_timer_status(:pause, :destroy)
  end

  def resume
    change_timer_status(:resume, :create)
  end

  def destroy
    timer.destroy!
    redirect_to timers_history_path
  end

  private

  def timer
    @timer ||= Timer.find(params[:id])
  end

  def change_timer_status(timer_operation, service_operation)
    if timer.send(timer_operation)
      StopTimerService.send(service_operation, timer)
      redirect_to timers_path
    else
      redirect_to timers_path, flash: { error: ERROR_MESSAGE }
    end
  end
end
