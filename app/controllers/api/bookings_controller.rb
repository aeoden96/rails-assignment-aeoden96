module Api
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_current_booking, only: [:update, :destroy, :show]
    before_action :authorize_action!, only: [:update, :destroy, :show]

    def index
      bookings = BookingsQuery.new(params).call
      render json: render_index_serializer(
        BookingSerializer,
        @current_user.admin? ? bookings : @current_user.bookings,
        :bookings
      )
    end

    def show
      render json: render_serializer_show(BookingSerializer, JsonapiSerializer::BookingSerializer,
                                          @current_booking, :booking)
    end

    def create
      booking = Booking.new(create_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking),
               status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    def update
      if @current_booking.update(update_params)
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
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id, :filter)
    end

    private

    def create_params
      @current_user.admin? ? booking_params : booking_params.merge(user_id: @current_user.id)
    end

    def update_params
      if !@current_user.admin? &&
         booking_params[:user_id].present?
        booking_params.except(:user_id)
      else
        booking_params
      end
    end

    def set_current_booking
      @current_booking = Booking.find(params[:id])
    end

    def authorize_action!
      return if @current_user.admin? || @current_user.id == @current_booking.user_id

      render json: { errors: { resource: ['is forbidden'] } },
             status: :forbidden
    end
  end
end
