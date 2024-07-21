# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Company, type: :model do
  company_params = { name: 'Croatia Airlines' }

  let(:company) { described_class.new(company_params) }

  describe 'validations' do
    it 'is valid with a valid name' do
      expect(company).to be_valid
    end

    it 'is not valid with a duplicate name' do
      described_class.create!(company_params)
      expect(company).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:flight).dependent(:destroy) }
  end
end
