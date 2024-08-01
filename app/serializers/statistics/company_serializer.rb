module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id

    field :id, name: :company_id

    field :total_revenue do |company|
      company.flights.sum do |flight|
        flight.bookings.sum do |booking|
          booking.no_of_seats * booking.seat_price
        end
      end
    end

    field :total_no_of_booked_seats do |company|
      company.flights.sum { |flight| flight.bookings.sum(:no_of_seats) }
    end

    field :average_price_of_seats do |company|
      total_no_of_booked_seats = company.flights.sum { |flight| flight.bookings.sum(:no_of_seats) }
      total_revenue = company.flights.sum do |flight|
        flight.bookings.sum do |booking|
          booking.no_of_seats * booking.seat_price
        end
      end
      total_revenue / total_no_of_booked_seats.to_f
    end
  end
end
