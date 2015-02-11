class PausesController < ApplicationController
  def index
    @timer = Timer.find(params[:id])
  end
end