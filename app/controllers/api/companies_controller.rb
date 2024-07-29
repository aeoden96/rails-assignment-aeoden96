module Api
  class CompaniesController < ApplicationController
    before_action :authenticate_user!, only: %i[create update destroy]
    before_action :authenticate_admin!, only: %i[create update destroy]

    def index
      # render json: render_index_serializer(CompanySerializer, Company.all, :companies)
      companies = CompaniesQuery.new(params).call
      render json: render_index_serializer(CompanySerializer, companies, :companies)
    end

    def show
      company = Company.find(params[:id])

      render json: render_serializer_show(CompanySerializer, JsonapiSerializer::CompanySerializer,
                                          company, :company)
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company, root: :company), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        render json: CompanySerializer.render(company, root: :company)
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      company = Company.find(params[:id])
      company.destroy

      head :no_content
    end

    def company_params
      params.require(:company).permit(:name, :filter)
    end
  end
end
