class BookingSerializer < Blueprinter::Base
  identifier :id

  fields :no_of_seats, :seat_price, :created_at, :updated_at

  view :include_associations do
    association :user, blueprint: UserSerializer
    association :flight, blueprint: FlightSerializer
  end
end
