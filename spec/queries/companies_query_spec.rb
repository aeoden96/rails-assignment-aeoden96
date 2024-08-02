require 'rails_helper'

RSpec.describe CompaniesQuery, type: :query do
  let!(:flights) { create_list(:flight, 3) }

  describe 'with_active_flights' do
    context 'when no active filter is applied' do
      it 'returns all companies ordered by name' do
        query = described_class.new(relation: Company.all, params: {}).with_active_flights
        expect(query).to eq([flights.first.company, flights.second.company, flights.third.company])
      end
    end

    context 'when active filter is applied' do
      it 'returns only companies with active flights' do
        flights.first.update(departs_at: Time.zone.today, arrives_at: Time.zone.today + 1.day)
        query = described_class.new(relation: Company.all,
                                    params: { filter: 'active' }).with_active_flights
        expect(query).to contain_exactly(flights.second.company,
                                         flights.third.company)
      end
    end
  end

  describe 'with_company_stats' do
    before do
      create_list(:booking, 10, flight: flights.first, no_of_seats: 1, seat_price: 100)
      create_list(:booking, 20, flight: flights.second, no_of_seats: 1, seat_price: 150)
      create_list(:booking, 15, flight: flights.second, no_of_seats: 1, seat_price: 200)
    end

    it 'calculates total revenue, total booked seats, and average price of seats' do
      query = described_class.new(relation: Company.all, params: {}).with_company_stats
      result1 = query.find(flights.first.company.id)
      result2 = query.find(flights.second.company.id)

      expect(result1.total_revenue).to eq(1000.0)
      expect(result1.total_no_of_booked_seats).to eq(10)
      expect(result1.average_price_of_seats).to eq(100.0)

      expect(result2.total_revenue).to eq(6000.0)
      expect(result2.total_no_of_booked_seats).to eq(35)
      expect(result2.average_price_of_seats).to eq(171.43)
    end

    context 'when a company has no bookings' do
      it 'returns 0 for total revenue, total booked seats, and average price of seats' do
        query = described_class.new(relation: Company.all, params: {}).with_company_stats
        result = query.find(flights.third.company.id)

        expect(result.total_revenue).to eq(0)
        expect(result.total_no_of_booked_seats).to eq(0)
        expect(result.average_price_of_seats).to eq(0.0)
      end
    end
  end
end
