RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let!(:company) { FactoryBot.create(:company) }
  # let!(:flight) { FactoryBot.create(:flight, company: company) }

  describe 'GET /companies' do
    context 'when flight have no bookings' do
      before do
        FactoryBot.create(:flight, company: company)
      end

      it 'calculates revenue' do
        get '/api/statistics/companies', headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['companies'].size).to eq(1)
        expect(json_body['companies'][0]).to include({
                                                       'company_id' => company.id,
                                                       'total_revenue' => 0.0,
                                                       'total_no_of_booked_seats' => 0,
                                                       'average_price_of_seats' => 0.0
                                                     })
      end
    end

    context 'when flight has bookings' do
      flight = nil

      before do
        flight = FactoryBot.create(:flight, company: company, no_of_seats: 10, base_price: 20)
        FactoryBot.create_list(:booking, 3, flight: flight, no_of_seats: 2, seat_price: 20)
      end

      it 'calculates revenue' do
        get '/api/statistics/companies', headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['companies'].size).to eq(1)
        expect(json_body['companies'][0]).to include({
                                                       'company_id' => company.id,
                                                       'total_revenue' => 120.0,
                                                       'total_no_of_booked_seats' => 6,
                                                       'average_price_of_seats' => 20.0
                                                     })
      end
    end
  end

  describe 'GET /flights' do
    context 'when flight has bookings' do
      flight = nil

      before do
        flight = FactoryBot.create(:flight, company: company, no_of_seats: 10, base_price: 20)
        FactoryBot.create_list(:booking, 3, flight: flight, no_of_seats: 2, seat_price: 20)
      end

      it 'calculates revenue' do
        get '/api/statistics/flights', headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['flights'].size).to eq(1)
        expect(json_body['flights'][0]).to include({
                                                     'flight_id' => flight.id,
                                                     'revenue' => 120,
                                                     'no_of_booked_seats' => 6,
                                                     'occupancy' => 60
                                                   })
      end
    end

    context 'when flight has no bookings' do
      before do
        FactoryBot.create(:flight, company: company)
      end

      it 'calculates revenue' do
        get '/api/statistics/flights', headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['flights'].size).to eq(1)
        expect(json_body['flights'][0]).to include({
                                                     'revenue' => 0,
                                                     'no_of_booked_seats' => 0,
                                                     'occupancy' => 0
                                                   })
      end
    end
  end
end
