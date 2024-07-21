module Api
  class FlightsController < ApplicationController
    def index
      render json: FlightSerializer.render(Flight.all)
    end

    def show
      flight = Flight.find(params[:id])

      render json: FlightSerializer.render(flight)
    end
  end
end
