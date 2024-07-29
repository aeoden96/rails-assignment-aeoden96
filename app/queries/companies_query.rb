class CompaniesQuery
  def initialize(params = {})
    @params = params
  end

  def call
    companies = Company.all
    companies = companies.with_active_flights if active_filter?
    companies.order(:name)
  end

  private

  def active_filter?
    @params[:filter] == 'active'
  end
end
