class BookingsQuery
  def initialize(params = {})
    @params = params
  end

  def with_active_flights
    bookings = Booking.includes(:flight)
                      .order('flights.departs_at ASC, flights.name ASC, bookings.created_at ASC')
    bookings = bookings.with_active_flights if @params[:filter] == 'active'
    bookings.order(:name)
  end
end
