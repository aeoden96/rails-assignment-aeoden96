class CompaniesQuery
  def initialize(relation:, params: {})
    @relation = relation
    @params = params
  end

  def with_active_flights
    companies = @relation
    companies = companies.with_active_flights if active_filter?
    companies.order(:name)
  end

  # rubocop:disable Metrics/MethodLength
  def with_company_stats
    total_booked_seats = <<-SQL
      COALESCE(SUM(bookings.no_of_seats), 0)
    SQL

    total_revenue = <<-SQL
      COALESCE(SUM(bookings.no_of_seats * bookings.seat_price), 0)
    SQL

    @relation
      .select('companies.*') # calls all columns from companies
      # equivalent to
      # total_revenue = first_non_null_value(SUM(bookings.no_of_seats * bookings.seat_price), 0)
      .select("#{total_revenue} AS total_revenue")
      # equivalent to
      # total_no_of_booked_seats = first_non_null_value(SUM(bookings.no_of_seats), 0)
      .select("#{total_booked_seats} AS total_no_of_booked_seats")
      # equivalent to
      # average_price_of_seats = total_booked_seats == 0 ? 0 : total_revenue / total_booked_seats
      .select("CASE
                 WHEN #{total_booked_seats} = 0 THEN 0
                 ELSE #{total_revenue} /
                      #{total_booked_seats}::float
               END AS average_price_of_seats")
      .left_joins(flights: :bookings) # company has many flights, so each flights calls bookings
      .group('companies.id') # used to compute average_price_of_seats for each company separately
  end
  # rubocop:enable Metrics/MethodLength

  private

  def active_filter?
    @params[:filter] == 'active'
  end
end
