RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:flight) { FactoryBot.create(:flight) }

  describe 'GET /bookings' do
    let!(:bookings) { FactoryBot.create_list(:booking, 3, user: user) }

    context 'when user is authorized and requests are valid' do
      it 'successfully returns a list of bookings' do
        get '/api/bookings', headers: api_headers(token: user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['bookings'].size).to eq(bookings.size)
      end

      it 'successfully returns a list of bookings without root' do
        get '/api/bookings', headers: api_headers(root: '0', token: user.token)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of 3 bookings without root' do
        get '/api/bookings', headers: api_headers(root: '0', token: user.token)

        expect(json_body.size).to eq(3)
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        get '/api/bookings'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is an admin' do
      it 'successfully returns a list of bookings' do
        other_bookings = FactoryBot.create_list(:booking, 3, user: other_user)

        get '/api/bookings', headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['bookings'].size).to eq(bookings.size + other_bookings.size)
      end
    end
  end

  describe 'GET /bookings/:id' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    context 'when user is authorized and requests are valid' do
      it 'successfully returns a single booking' do
        get "/api/bookings/#{booking.id}", headers: api_headers(token: user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body).to include('booking')
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        get "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not the owner of the booking' do
      it 'returns 403 Forbidden' do
        get "/api/bookings/#{booking.id}", headers: api_headers(token: other_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the record does not exist' do
      it 'returns 404 Not Found' do
        get '/api/bookings/0', headers: api_headers(token: user.token)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is an admin' do
      it 'successfully returns a single booking' do
        get "/api/bookings/#{booking.id}", headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:ok)
        expect(json_body).to include('booking')
      end
    end

    describe 'when header X-API-SERIALIZER is jsonapi' do
      it 'successfully returns a single booking using jsonapi' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(serializer: 'jsonapi', token: user.token)

        expect(response).to have_http_status(:ok)
      end

      it 'returns a single booking using jsonapi' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(serializer: 'jsonapi', token: user.token)

        expect(json_body).to include('data')
        expect(json_body['data']).to include('id')
        expect(json_body['data']).to include('relationships')
        expect(json_body['data']).to include('type')
      end
    end
  end

  describe 'POST /bookings/:id' do
    context 'when user is authenticated and requests are valid' do
      it 'creates a bookings' do
        expect do
          post '/api/bookings',
               params: { booking: {
                 no_of_seats: 2, seat_price: 150,
                 user_id: user.id,
                 flight_id: flight.id
               } }.to_json,
               headers: api_headers(token: user.token)
        end.to change(Booking, :count).by(1)
        expect(json_body['booking']).to include('no_of_seats' => 2)
      end
    end

    context 'when user is authenticated and params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 0 } }.to_json,
             headers: api_headers(token: user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 2 } }.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is an admin' do
      it 'creates a bookings' do
        expect do
          post '/api/bookings',
               params: { booking: {
                 no_of_seats: 2, seat_price: 150,
                 user_id: user.id,
                 flight_id: flight.id
               } }.to_json,
               headers: api_headers(token: admin.token)
        end.to change(Booking, :count).by(1)
        expect(json_body['booking']).to include('no_of_seats' => 2)
      end
    end
  end

  describe 'PUT /bookings/:id' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    context 'when user is authenticated and requests are valid' do
      it 'updates a booking' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: user.token)

        expect(Booking.first.no_of_seats).to eq(200)
        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('no_of_seats' => 200)
      end
    end

    context 'when user is authenticated and params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 0 } }.to_json,
            headers: api_headers(token: user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end

      it 'does not update the user if the user is not an admin' do
        expect do
          put "/api/bookings/#{booking.id}",
              params: { booking: { user_id: other_user.id } }.to_json,
              headers: api_headers(token: user.token)
        end.not_to(change { booking.reload.user_id })
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 200 } }.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not the owner of the booking' do
      it 'returns 403 Forbidden' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: other_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is an admin' do
      it 'updates a booking' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: admin.token)

        expect(Booking.first.no_of_seats).to eq(200)
        expect(response).to have_http_status(:ok)
        expect(json_body['booking']).to include('no_of_seats' => 200)
      end
    end
  end

  describe 'DELETE /bookings/:id' do
    let!(:booking) { FactoryBot.create(:booking, user: user) }

    context 'when user is authenticated and requests are valid' do
      it 'deletes a booking' do
        expect do
          delete "/api/bookings/#{booking.id}", headers: api_headers(token: user.token)
        end.to change(Booking, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        delete "/api/bookings/#{booking.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not the owner of the booking' do
      it 'returns 403 Forbidden' do
        delete "/api/bookings/#{booking.id}", headers: api_headers(token: other_user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is an admin' do
      it 'deletes a booking' do
        expect do
          delete "/api/bookings/#{booking.id}", headers: api_headers(token: admin.token)
        end.to change(Booking, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the record does not exist' do
      it 'returns 404 Not Found' do
        delete '/api/bookings/0', headers: api_headers(token: user.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
