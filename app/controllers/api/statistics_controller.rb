module Api
  class StatisticsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!
    # before_action :set_current_booking, only: [:update, :destroy, :show]
    # before_action :authorize_action!, only: [:update, :destroy, :show]

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
