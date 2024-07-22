RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  let!(:bookings) { FactoryBot.create_list(:booking, 3) }
  let(:user) { FactoryBot.create(:user) }
  let(:flight) { FactoryBot.create(:flight) }

  describe 'GET /bookings' do
    it 'successfully returns a list of bookings' do
      get '/api/bookings'

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of 3 bookings' do
      get '/api/bookings'

      json_body = JSON.parse(response.body)
      expect(json_body['bookings'].size).to eq(3)
    end

    it 'successfully returns a list of bookings without root' do
      get '/api/bookings', headers: alternative_index_serializer_headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of 3 bookings without root' do
      get '/api/bookings', headers: alternative_index_serializer_headers

      json_body = JSON.parse(response.body)
      expect(json_body.size).to eq(3)
    end
  end

  describe 'GET /bookings/:id' do
    it 'successfully returns a single booking' do
      get "/api/bookings/#{bookings.first.id}"

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single booking' do
      get "/api/bookings/#{bookings.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body).to include('booking')
    end

    it 'successfully returns a single booking using jsonapi' do
      get "/api/bookings/#{bookings.first.id}", headers: alternative_show_serializer_headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single booking using jsonapi' do
      get "/api/bookings/#{bookings.first.id}", headers: alternative_show_serializer_headers

      json_body = JSON.parse(response.body)

      expect(json_body).to include('data')
      expect(json_body['data']).to include('id')
      expect(json_body['data']).to include('relationships')
      expect(json_body['data']).to include('type')
    end
  end

  describe 'POST /bookings/:id' do
    context 'when params are valid' do
      it 'creates a bookings' do
        post '/api/bookings',
             params: { booking: {
               no_of_seats: 2,
               seat_price: 150,
               user_id: user.id,
               flight_id: flight.id
             } }.to_json,
             headers: api_headers

        expect(json_body['booking']).to include('no_of_seats' => 2)
      end

      it 'the number of records in the resource table is incremented by one' do
        post '/api/bookings',
             params: { booking: {
               no_of_seats: 2,
               seat_price: 150,
               user_id: user.id,
               flight_id: flight.id
             } }.to_json,
             headers: api_headers

        expect(Booking.count).to eq(4)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 0 } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'PUT /bookings/:id' do
    context 'when params are valid' do
      it 'updates a booking' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers
        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('no_of_seats' => 200)
      end

      it 'the updates are persisted in database' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers

        expect(Booking.first.no_of_seats).to eq(200)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { no_of_seats: 0 } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'DELETE /bookings/:id' do
    context 'when the record exists' do
      it 'deletes a booking' do
        delete "/api/bookings/#{bookings.first.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'the number of records in the resource table is decremented by one' do
        delete "/api/bookings/#{bookings.first.id}"

        expect(Booking.count).to eq(2)
      end
    end
  end
end
