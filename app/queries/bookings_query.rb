class BookingsQuery
  def initialize(scope = Booking.all, params = {})
    @params = params
    @scope = scope
  end

  def with_active_flights
    bookings = @scope.order('flights.departs_at ASC, flights.name ASC, bookings.created_at ASC')
    bookings = bookings.with_active_flights if @params[:filter] == 'active'

    bookings
  end
end
