module Api
  class FlightsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :authorize_admin!, only: [:create, :update, :destroy]

    def index
      flights = FlightsQuery.new(relation: Flight.all.includes(:company),
                                 params: params).with_filters
      render json: render_index_serializer(FlightSerializer, flights, :flights)
    end

    def show
      flight = Flight.find(params[:id])

      render json: render_serializer_show(FlightSerializer, JsonapiSerializer::FlightSerializer,
                                          flight, :flight)
    end

    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: :flight),
               status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def update
      flight = Flight.find(params[:id])

      if flight.update(flight_params)
        render json: FlightSerializer.render(flight, root: :flight)
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    def destroy
      flight = Flight.find(params[:id])
      flight.destroy

      head :no_content
    end

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at,
                                     :company_id, :filter)
    end
  end
end
