module Statistics
  class FlightSerializer < Blueprinter::Base
    identifier :id

    field :id, name: :flight_id
    fields :revenue, :no_of_booked_seats, :occupancy
  end
end
