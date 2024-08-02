module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id

    field :id, name: :company_id
    fields :total_revenue, :total_no_of_booked_seats, :average_price_of_seats
  end
end
