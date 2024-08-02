module Statistics
  class FlightSerializer < Blueprinter::Base
    identifier :id

    field :id, name: :flight_id

    field :revenue do |flight|
      flight.bookings.sum { |booking| booking.no_of_seats * booking.seat_price }
    end

    field :no_of_booked_seats do |flight|
      flight.bookings.sum(:no_of_seats)
    end

    field :occupancy do |flight|
      (flight.bookings.sum(:no_of_seats) / flight.no_of_seats.to_f * 100).round(2)
    end
  end
end
