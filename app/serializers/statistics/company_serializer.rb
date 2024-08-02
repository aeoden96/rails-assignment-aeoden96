module Statistics
  class CompanySerializer < Blueprinter::Base
    identifier :id

    field :id, name: :company_id
    field :total_no_of_booked_seats

    field :total_revenue do |company|
      company.total_revenue.to_f
    end

    field :average_price_of_seats do |company|
      company.average_price_of_seats.to_f
    end
  end
end
