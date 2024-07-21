class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email

  view :include_associations do
    fields :first_name, :last_name
    association :bookings, blueprint: BookingSerializer
    association :flights, blueprint: FlightSerializer
  end
end
