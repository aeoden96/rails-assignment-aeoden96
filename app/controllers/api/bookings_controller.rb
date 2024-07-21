module Api
  class BookingsController < ApplicationController
    def index
      render json: BookingSerializer.render(Booking.all)
    end

    def show
      booking = Booking.find(params[:id])

      render json: BookingSerializer.render(booking)
    end

    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking), status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: BookingSerializer.render(booking)
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking = Booking.find(params[:id])
      booking.destroy

      render json: BookingSerializer.render(booking)
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
