class TimerController < ApplicationController
  def index
  end

  def list
    @timers = Timer.all
  end
end
