module Api
  class FlightsController < ApplicationController
    def index
      render json: FlightSerializer.render(Flight.all)
    end

    def show
      flight = Flight.find(params[:id])

      render json: FlightSerializer.render(flight)
    end

    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: FlightSerializer.render(flight), status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      flight = Flight.find(params[:id])

      if flight.update(flight_params)
        render json: FlightSerializer.render(flight)
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      flight = Flight.find(params[:id])
      flight.destroy

      render json: FlightSerializer.render(flight)
    end

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at,
                                     :company_id)
    end
  end
end
