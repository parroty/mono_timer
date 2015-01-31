class TimerController < ApplicationController
  def index
  end

  def new
    @timer = Timer.new
  end

  def list
    @timers = Timer.all
  end
end
