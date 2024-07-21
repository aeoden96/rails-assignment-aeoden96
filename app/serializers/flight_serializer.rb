class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name, :base_price, :no_of_seats, :departs_at, :arrives_at, :created_at, :updated_at

  view :include_associations do
    association :company, blueprint: CompanySerializer
    association :bookings, blueprint: BookingSerializer
    association :users, blueprint: UserSerializer
  end
end
