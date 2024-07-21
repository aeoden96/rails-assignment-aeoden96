class CompanySerializer < Blueprinter::Base
  identifier :id

  fields :name, :created_at, :updated_at

  view :include_associations do
    association :flights, blueprint: FlightSerializer
  end
end
