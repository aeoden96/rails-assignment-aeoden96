RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse
  let!(:flights) { FactoryBot.create_list(:flight, 3) }
  let(:company) { FactoryBot.create(:company) }
  let(:admin) { FactoryBot.create(:user, role: 'admin') }

  describe 'GET /flights' do
    it 'successfully returns a list of flights' do
      get '/api/flights'

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of 3 flights' do
      get '/api/flights'

      json_body = JSON.parse(response.body)
      expect(json_body['flights'].size).to eq(3)
    end

    describe 'when header X-API-SERIALIZER-ROOT is false' do
      it 'successfully returns a list of flights without root' do
        get '/api/flights', headers: api_headers(root: '0')

        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of 3 flights without root' do
        get '/api/flights', headers: api_headers(root: '0')

        json_body = JSON.parse(response.body)
        expect(json_body.size).to eq(3)
      end
    end
  end

  describe 'GET /flights/:id' do
    it 'successfully returns a single flight' do
      get "/api/flights/#{flights.first.id}"

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single flight' do
      get "/api/flights/#{flights.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body).to include('flight')
    end

    describe 'when header X-API-SERIALIZER is jsonapi' do
      it 'successfully returns a single flight using jsonapi' do
        get "/api/flights/#{flights.first.id}", headers: api_headers(serializer: 'jsonapi')

        expect(response).to have_http_status(:ok)
      end

      it 'returns a single flight using jsonapi' do
        get "/api/flights/#{flights.first.id}", headers: api_headers(serializer: 'jsonapi')

        json_body = JSON.parse(response.body)

        expect(json_body).to include('data')
        expect(json_body['data']).to include('id')
        expect(json_body['data']).to include('relationships')
        expect(json_body['data']).to include('type')
      end
    end
  end

  describe 'POST /flights/:id' do
    json_params = { name: 'Croatia Airlines',
                    no_of_seats: 2,
                    base_price: 150,
                    departs_at: '2021-12-12 12:00:00',
                    arrives_at: '2021-12-12 14:00:00' }

    context 'when params are valid' do
      it 'creates a flights' do
        post '/api/flights',
             params: { flight: {
               **json_params,
               company_id: company.id
             } }.to_json,
             headers: api_headers(token: admin.token)

        expect(json_body['flight']).to include('no_of_seats' => 2)
      end

      it 'the number of records in the resource table is incremented by one' do
        expect do
          post '/api/flights',
               params: { flight: {
                 **json_params,
                 company_id: company.id
               } }.to_json,
               headers: api_headers(token: admin.token)
        end.to change(Flight, :count).by(1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { no_of_seats: 0 } }.to_json,
             headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'PUT /flights/:id' do
    context 'when params are valid' do
      it 'updates a flight' do
        put "/api/flights/#{flights.first.id}",
            params: { flight: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['flight']).to include('no_of_seats' => 200)
      end

      it 'the updates are persisted in database' do
        put "/api/flights/#{flights.first.id}",
            params: { flight: { no_of_seats: 200 } }.to_json,
            headers: api_headers(token: admin.token)

        expect(Flight.first.no_of_seats).to eq(200)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/flights/#{flights.first.id}",
            params: { flight: { no_of_seats: 0 } }.to_json,
            headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('no_of_seats')
      end
    end
  end

  describe 'DELETE /flights/:id' do
    context 'when the record exists' do
      it 'deletes a flight' do
        delete "/api/flights/#{flights.first.id}", headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:no_content)
      end

      it 'the number of records in the resource table is decremented by one' do
        expect do
          delete "/api/flights/#{flights.first.id}", headers: api_headers(token: admin.token)
        end.to change(Flight, :count).by(-1)
      end
    end
  end
end
