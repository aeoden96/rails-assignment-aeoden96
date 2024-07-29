class BookingsQuery
  def initialize(params = {})
    @params = params
  end

  def call
    bookings = Booking.all
    bookings = bookings.with_active_flights if active_filter?
    bookings.order(:name)
  end

  private

  def active_filter?
    @params[:filter] == 'active'
  end
end
