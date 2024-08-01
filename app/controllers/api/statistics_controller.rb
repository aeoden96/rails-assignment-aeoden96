module Api
  class StatisticsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def flights_index
      flights = FlightsQuery.new(params).call
      render json: render_index_serializer(Statistics::FlightSerializer, flights, :flights)
    end

    def companies_index
      companies = CompaniesQuery.new(params).call
      render json: render_index_serializer(Statistics::CompanySerializer, companies, :companies)
    end
  end
end
