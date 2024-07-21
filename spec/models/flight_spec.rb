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
  flight_params = {
    name: 'Flight #2250',
    no_of_seats: 100,
    base_price: 200,
    departs_at: DateTime.now + 3.days,
    arrives_at: DateTime.now + 4.days
  }

  let(:company) { Company.create(name: 'Croatia Airlines') }
  let(:company2) { Company.create(name: 'Lufthansa') }
  let(:flight) do
    described_class.new(flight_params.merge(company: company))
  end

  describe 'validations' do
    it 'all attributes are valid' do
      expect(flight).to be_valid
    end

    describe 'name' do
      it 'is not valid without a name' do
        flight.name = nil
        expect(flight).not_to be_valid
      end

      it 'is not valid with a duplicate name' do
        described_class.create!(flight_params.merge(company: company))
        expect(flight).not_to be_valid
      end

      it 'is valid with a duplicate name in a different company' do
        described_class.create!(flight_params.merge(company: company2))
        expect(flight).to be_valid
      end
    end

    it 'is not valid if departs_at is not before arrives_at' do
      flight.departs_at = DateTime.now + 3.days
      flight.arrives_at = DateTime.now + 2.days
      expect(flight).not_to be_valid
      expect(flight.errors[:departs_at]).to include('must be before arrives_at')
    end

    it 'is not valid with a base price less than or equal to 0' do
      flight.base_price = 0
      expect(flight).not_to be_valid
    end

    it 'is not valid with a number of seats <= 0' do
      flight.no_of_seats = 0
      expect(flight).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:users).through(:bookings) }
  end
end
