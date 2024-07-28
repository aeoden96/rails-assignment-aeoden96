RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  let(:user) { FactoryBot.create(:user) }
  let!(:bookings) { FactoryBot.create_list(:booking, 3, user: user) }
  let(:flight) { FactoryBot.create(:flight) }

  describe 'GET /bookings' do
    context 'when user is authorized and requests are valid' do
      before do
        user.login
      end

      it 'successfully returns a list of bookings' do
        get '/api/bookings', headers: api_headers(token: user.token)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of 3 bookings' do
        get '/api/bookings', headers: api_headers(token: user.token)

        json_body = JSON.parse(response.body)
        expect(json_body['bookings'].size).to eq(3)
      end

      it 'successfully returns a list of bookings without root' do
        get '/api/bookings', headers: api_headers(root: '0', token: user.token)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of 3 bookings without root' do
        get '/api/bookings', headers: api_headers(root: '0', token: user.token)

        json_body = JSON.parse(response.body)
        expect(json_body.size).to eq(3)
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        get '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /bookings/:id' do
    it 'successfully returns a single booking' do
      get "/api/bookings/#{bookings.first.id}", headers: api_headers(token: user.token)

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single booking' do
      get "/api/bookings/#{bookings.first.id}", headers: api_headers(token: user.token)

      json_body = JSON.parse(response.body)

      expect(json_body).to include('booking')
    end

    describe 'when header X-API-SERIALIZER is jsonapi' do
      it 'successfully returns a single booking using jsonapi' do
        get "/api/bookings/#{bookings.first.id}",
            headers: api_headers(serializer: 'jsonapi', token: user.token)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a single booking using jsonapi' do
        get "/api/bookings/#{bookings.first.id}",
            headers: api_headers(serializer: 'jsonapi', token: user.token)

        json_body = JSON.parse(response.body)

        expect(json_body).to include('data')
        expect(json_body['data']).to include('id')
        expect(json_body['data']).to include('relationships')
        expect(json_body['data']).to include('type')
      end
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
             headers: api_headers(token: user.token)

        expect(json_body['booking']).to include('no_of_seats' => 2)
      end

      it 'the number of records in the resource table is incremented by one' do
        expect do
          post '/api/bookings',
               params: { booking: {
                 no_of_seats: 2,
                 seat_price: 150,
                 user_id: user.id,
                 flight_id: flight.id
               } }.to_json,
               headers: api_headers(token: user.token)
        end.to change(Booking, :count).by(1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 0 } }.to_json,
             headers: api_headers(token: user.token)

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
            headers: api_headers(token: user.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('no_of_seats' => 200)
      end

      it 'the updates are persisted in database' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: user.token)

        expect(Booking.first.no_of_seats).to eq(200)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{bookings.first.id}",
            params: { booking: { no_of_seats: 0 } }.to_json,
            headers: api_headers(token: user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'DELETE /bookings/:id' do
    context 'when the record exists' do
      it 'deletes a booking' do
        delete "/api/bookings/#{bookings.first.id}", headers: api_headers(token: user.token)

        expect(response).to have_http_status(:no_content)
      end

      it 'the number of records in the resource table is decremented by one' do
        expect do
          delete "/api/bookings/#{bookings.first.id}", headers: api_headers(token: user.token)
        end.to change(Booking, :count).by(-1)
      end
    end
  end
end
