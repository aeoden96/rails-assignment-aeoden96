module Api
  class BookingsController < ApplicationController
    def index
      render json: render_index_serializer(BookingSerializer, Booking.all, :bookings)
    end

    def show
      booking = Booking.find(params[:id])

      render json: render_serializer_show(BookingSerializer, JsonapiSerializer::BookingSerializer,
                                          booking, :booking)
    end

    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking),
               status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      booking = Booking.find(params[:id])

      if booking.update(booking_params)
        render json: BookingSerializer.render(booking, root: :booking)
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def destroy
      booking = Booking.find(params[:id])
      booking.destroy

      head :no_content
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
