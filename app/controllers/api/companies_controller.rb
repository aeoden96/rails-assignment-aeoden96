module Api
  class CompaniesController < ApplicationController
    def index
      render json: CompanySerializer.render(Company.all)
    end

    def show
      company = Company.find(params[:id])

      render json: CompanySerializer.render(company)
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      company = Company.find(params[:id])

      if company.update(company_params)
        render json: CompanySerializer.render(company)
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      company = Company.find(params[:id])
      company.destroy

      render json: CompanySerializer.render(company)
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
