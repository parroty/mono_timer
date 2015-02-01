class TimerController < ApplicationController
  def index
  end

  def new
    @timer = Timer.new
  end

  def list
    @timers = Timer.all
  end

  def create
    Timer.create!(start_time: DateTime.now)
    redirect_to timer_index_path
  end
end
