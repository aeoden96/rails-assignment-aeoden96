class FlightsQuery
  def initialize(relation: Flight.all, params: {})
    @params = params
    @relation = relation
  end

  def with_filters
    flights = @relation
              .order('departs_at ASC, name ASC, created_at ASC').upcoming
    flights = flights.filter_by_name(@params[:name_cont]) if @params[:name_cont].present?
    flights = flights.filter_by_date(@params[:departs_at_eq]) if @params[:departs_at_eq].present?
    if @params[:no_of_available_seats_gteq].present?
      flights = flights.filter_by_availability(
        @params[:no_of_available_seats_gteq]
      )
    end
    flights
  end

  def with_stats
    @relation.select('flights.*') # calls all columns from flights
             # equivalent to
             # revenue = first_non_null_value(SUM(bookings.no_of_seats * bookings.seat_price), 0)
             .select('COALESCE(SUM(bookings.no_of_seats * bookings.seat_price), 0) AS revenue')
             # equivalent to
             # no_of_booked_seats = first_non_null_value(SUM(bookings.no_of_seats), 0)
             .select('COALESCE(SUM(bookings.no_of_seats), 0) AS no_of_booked_seats')
             # equivalent to
             # occupancy = no_of_booked_seats / flights.no_of_seats * 100
             .select('COALESCE(SUM(bookings.no_of_seats) /
              flights.no_of_seats::float * 100, 0) AS occupancy') # adds ::float for non-int div
             .left_joins(:bookings) # adds bookings to each flight
             .group('flights.id') # used to compute occupancy for each flight separately
  end
end
