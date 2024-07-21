module Api
  class BookingsController < ApplicationController
    def index
      render json: BookingSerializer.render(Booking.all)
    end

    def show
      booking = Booking.find(params[:id])

      render json: BookingSerializer.render(booking)
    end
  end
end
