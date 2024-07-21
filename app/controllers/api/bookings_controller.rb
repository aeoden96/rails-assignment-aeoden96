module Api
  class BookingsController < ApplicationController
    def index
      render json: BookingSerializer.render(Booking.all, view: :include_associations,
                                                         root: :bookings)
    end

    def show
      booking = Booking.find(params[:id])

      render json: BookingSerializer.render(booking, view: :include_associations, root: :booking)
    end

    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, view: :include_associations, root: :booking),
               status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: BookingSerializer.render(booking, view: :include_associations, root: :booking)
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking = Booking.find(params[:id])
      booking.destroy

      render json: { message: 'Booking deleted' }, status: :no_content
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
