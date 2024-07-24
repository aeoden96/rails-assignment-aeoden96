class CompanyForm
  include ActiveModel::Model

  attr_accessor :name, :company, :id, :created_at, :updated_at

  validates :name, presence: true

  def errors
    @company.errors
  end

  def update(params)
    @company.attributes = params
    return false unless @company.valid?

    @company.save
  end

  def initialize(company_or_params = {})
    @company = company_or_params.is_a?(Company) ? company_or_params : Company.new(company_or_params)
  end

  def save
    return unless valid?

    @company.save
  end
end
