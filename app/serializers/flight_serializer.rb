class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name, :base_price, :no_of_seats, :departs_at, :arrives_at, :created_at, :updated_at

  association :company, blueprint: CompanySerializer
end
