module Api
  class CompaniesController < ApplicationController
    def index
      render json: CompanySerializer.render(Company.all, view: :include_associations)
    end

    def show
      company = Company.find(params[:id])

      render json: CompanySerializer.render(company, view: :include_associations)
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

      render json: { message: 'Company deleted' }, status: :no_content
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
