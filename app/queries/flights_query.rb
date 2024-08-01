class FlightsQuery
  def initialize(params = {})
    @params = params
  end

  def with_filters
    flights = Flight.all.includes(:company)
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
end
