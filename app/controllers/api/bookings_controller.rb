module Api
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_booking, only: [:update, :destroy, :show]
    before_action :authorize_action!, only: [:update, :destroy, :show]

    def index
      render json: render_index_serializer(
        BookingSerializer,
        @current_user.admin? ? Booking.all : @current_user.bookings,
        :bookings
      )
    end

    def show
      render json: render_serializer_show(BookingSerializer, JsonapiSerializer::BookingSerializer,
                                          @current_booking, :booking)
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
      booking_params.delete(:user_id) unless @current_user.admin?

      if @current_booking.update(booking_params)
        render json: BookingSerializer.render(@current_booking, root: :booking)
      else
        render json: { errors: @current_booking.errors }, status: :bad_request
      end
    end

    def destroy
      @current_booking.destroy

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
      return unless @current_user.id != @current_booking.user_id && !@current_user.admin?

      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
