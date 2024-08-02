module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id

    field :id, name: :company_id

    def self.calc_total_revenue(company)
      company.flights.sum do |flight|
        flight.bookings.sum do |booking|
          booking.no_of_seats * booking.seat_price
        end
      end
    end

    field :total_revenue do |company|
      calc_total_revenue(company)
    end

    field :total_no_of_booked_seats do |company|
      company.flights.sum { |flight| flight.bookings.sum(:no_of_seats) }
    end

    field :average_price_of_seats do |company|
      total_no_of_booked_seats = company.flights.sum { |flight| flight.bookings.sum(:no_of_seats) }
      total_revenue = calc_total_revenue(company)

      if total_no_of_booked_seats.zero?
        0
      else
        total_revenue / total_no_of_booked_seats.to_f
      end
    end
  end
end
