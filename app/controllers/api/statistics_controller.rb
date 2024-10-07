module Api
  class StatisticsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def flights_index
      flights_query = FlightsQuery.new(relation: Flight.all, params: params)

      flights = flights_query.with_stats.merge(flights_query.with_filters)

      render json: render_index_serializer(Statistics::FlightSerializer, flights,
                                           :flights)
    end

    def companies_index
      companies_query = CompaniesQuery.new(relation: Company.all, params: params)
      comanies_active = companies_query.with_active_flights

      companies = companies_query.with_company_stats.merge(comanies_active)

      render json: render_index_serializer(Statistics::CompanySerializer, companies,
                                           :companies)
    end
  end
end
