class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name, :base_price, :no_of_seats

  view :minimal do
    fields :id, :name, :base_price
  end
end
