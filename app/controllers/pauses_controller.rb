class PausesController < ApplicationController
  def index
    @timer = Timer.find(params[:id])
    @pauses = @timer.pauses.page(params[:page]).order("id desc")
  end
end
