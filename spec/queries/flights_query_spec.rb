require 'rails_helper'

RSpec.describe FlightsQuery, type: :query do
  let(:flights) { create_list(:flight, 3, no_of_seats: 200, base_price: 150) }

  describe 'with_filters' do
    context 'when no filters are applied' do
      it 'returns all upcoming flights ordered by departs_at, name, and created_at' do
        query = described_class.new.with_filters
        expect(query).to eq(flights)
      end
    end

    context 'when filtering by name' do
      it 'returns flights matching the name' do
        query = described_class.new(params: { name_cont: flights.first.name }).with_filters
        expect(query).to contain_exactly(flights.first)
      end
    end

    context 'when filtering by departs_at date' do
      it 'returns flights matching the exact departs_at date' do
        query = described_class.new(params: {
                                      departs_at_eq: flights.first.departs_at.to_date.to_s
                                    }).with_filters
        expect(query).to contain_exactly(flights.first)
      end
    end
  end

  describe 'with_stats' do
    context 'when flight has bookings' do
      flight = nil

      before do
        flight = FactoryBot.create(:flight, no_of_seats: 10, base_price: 20)
        FactoryBot.create_list(:booking, 3, flight: flight, no_of_seats: 2, seat_price: 20)
      end

      it 'calculates revenue' do
        query = described_class.new.with_stats
        expect(query.first.revenue).to eq(120)
        expect(query.first.no_of_booked_seats).to eq(6)
        expect(query.first.occupancy).to eq(60)
      end
    end

    context 'when flight has no bookings' do
      before do
        FactoryBot.create(:flight)
      end

      it 'calculates revenue' do
        query = described_class.new.with_stats
        expect(query.first.revenue).to eq(0)
        expect(query.first.no_of_booked_seats).to eq(0)
        expect(query.first.occupancy).to eq(0)
      end
    end
  end
end
