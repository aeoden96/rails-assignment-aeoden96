class FlightsQuery
  def initialize(params = {})
    @params = params
  end

  def call
    flights = Flight.all
    flights = flights.upcoming if active_filter?
    flights.order(:name)
  end

  private

  def active_filter?
    @params[:filter] == 'active'
  end
end
