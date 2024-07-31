# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  no_of_seats :integer
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  arrives_at  :datetime         not null
#  company_id  :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Flight, type: :model do
  let(:company) { create(:company) }
  let!(:flight) do
    create(:flight, company: company,
                    base_price: 12_345,
                    departs_at: DateTime.now + 1.day,
                    arrives_at: DateTime.now + 3.days)
  end

  let(:flight2) do
    create(:flight, company: company, departs_at: DateTime.now + 5.days,
                    arrives_at: DateTime.now + 8.days)
  end

  describe 'validations' do
    it 'all attributes are valid' do
      expect(flight).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

    describe 'name uniqueness' do
      subject { create(:flight) }

      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:company_id).case_insensitive }
    end

    it 'is not valid if departs_at is not before arrives_at' do
      flight.departs_at = DateTime.now + 3.days
      flight.arrives_at = DateTime.now + 2.days
      expect(flight).not_to be_valid
      expect(flight.errors[:departs_at]).to include('must be before arrives_at')
    end
  end

  describe 'check overlaping beetwen flights in same company' do
    it 'when overlaps with another flight is invalid' do
      flight2.departs_at = DateTime.now + 2.days
      flight2.arrives_at = DateTime.now + 6.days
      expect(flight2).not_to be_valid
      expect(flight2.errors[:departs_at]).to include('overlap with another flight in same company')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:users).through(:bookings) }
  end
end
