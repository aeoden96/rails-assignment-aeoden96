module Api
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_booking, only: %i[update]
    before_action :authorize_action!, only: %i[update]

    def index
      render json: render_index_serializer(BookingSerializer, @current_user.bookings, :bookings)
    end

    def show
      booking = Booking.find(params[:id])

      render json: render_serializer_show(BookingSerializer, JsonapiSerializer::BookingSerializer,
                                          booking, :booking)
    end

    def create
      # if @current_user.id != booking_params[:user_id].to_i
      #  render json: { errors: ['Not Authorized'] }, status: :unauthorized
      # end
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

    private

    def set_current_booking
      @current_booking = Booking.find(params[:id])
    end

    def authorize_action!
      return unless @current_user.id != @current_booking.user_id

      render json: { errors: { token: ['is invalid'] } },
             status: :unauthorized
    end
  end
end
