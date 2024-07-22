RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse
  let!(:users) { FactoryBot.create_list(:user, 3) }

  describe 'GET /users' do
    it 'successfully returns a list of users' do
      get '/api/users'

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of 3 users' do
      get '/api/users'

      json_body = JSON.parse(response.body)
      expect(json_body['users'].size).to eq(3)
    end
  end

  describe 'GET /users/:id' do
    it 'successfully returns a single user' do
      get "/api/users/#{users.first.id}"

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single user' do
      get "/api/users/#{users.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body).to include('user')
    end
  end

  describe 'POST /users/:id' do
    user_json_params = { first_name: 'John', last_name: 'Doe', email: 'john@gmail.com' }
    context 'when params are valid' do
      it 'creates a user' do
        post '/api/users',
             params: { user: user_json_params }.to_json,
             headers: api_headers

        expect(json_body['user']).to include('first_name' => 'John')
      end

      it 'the number of records in the resource table is incremented by one' do
        post '/api/users',
             params: { user: user_json_params }.to_json,
             headers: api_headers

        expect(User.count).to eq(4)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/users',
             params: { user: { first_name: 'John', last_name: 'Doe', email: '' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('email')
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when params are valid' do
      it 'updates a user' do
        put "/api/users/#{users.first.id}",
            params: { user: { first_name: 'Alex' } }.to_json,
            headers: api_headers
        expect(response).to have_http_status(:ok)
        expect(json_body['user']).to include('first_name' => 'Alex')
      end

      it 'the updates are persisted in database' do
        put "/api/users/#{users.first.id}",
            params: { user: { first_name: 'Alex' } }.to_json,
            headers: api_headers

        expect(User.first.first_name).to eq('Alex')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/users/#{users.first.id}",
            params: { user: { first_name: '' } }.to_json,
            headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('first_name')
      end
    end
  end

  describe 'DELETE /users/:id' do
    context 'when the record exists' do
      it 'deletes a user' do
        delete "/api/users/#{users.first.id}"

        expect(response).to have_http_status(:no_content)
      end

      it 'the number of records in the resource table is decremented by one' do
        delete "/api/users/#{users.first.id}"

        expect(User.count).to eq(2)
      end
    end
  end
end
