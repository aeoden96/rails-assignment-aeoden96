class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :created_at, :updated_at

  view :include_associations do
    association :bookings, blueprint: BookingSerializer
    association :flights, blueprint: FlightSerializer
  end
end
