RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse
  let!(:companies) { FactoryBot.create_list(:company, 3) }
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /companies' do
    it 'successfully returns a list of companies' do
      get '/api/companies'

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of 3 companies' do
      get '/api/companies'

      json_body = JSON.parse(response.body)
      expect(json_body['companies'].size).to eq(3)
    end

    describe 'when header X-API-SERIALIZER-ROOT is false' do
      it 'successfully returns a list of companies without root' do
        get '/api/companies', headers: api_headers(root: '0')

        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of 3 companies without root' do
        get '/api/companies', headers: api_headers(root: '0')

        json_body = JSON.parse(response.body)
        expect(json_body.size).to eq(3)
      end
    end
  end

  describe 'GET /companies/:id' do
    it 'successfully returns a single company' do
      get "/api/companies/#{companies.first.id}"

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single company' do
      get "/api/companies/#{companies.first.id}"

      json_body = JSON.parse(response.body)

      expect(json_body).to include('company')
    end

    describe 'when header X-API-SERIALIZER is jsonapi' do
      it 'successfully returns a single company using jsonapi' do
        get "/api/companies/#{companies.first.id}", headers: api_headers(serializer: 'jsonapi')

        expect(response).to have_http_status(:ok)
      end

      it 'returns a single company using jsonapi' do
        get "/api/companies/#{companies.first.id}", headers: api_headers(serializer: 'jsonapi')

        json_body = JSON.parse(response.body)

        expect(json_body).to include('data')
        expect(json_body['data']).to include('id')
        expect(json_body['data']).to include('type')
      end
    end
  end

  describe 'POST /companies/:id' do
    context 'when user is unauthenticated' do
      it 'returns 401 Unauthorized' do
        post '/api/companies',
             params: { company: { name: 'Croatia Airlines' } }.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated but not authorized' do
      it 'returns 403 Forbidden' do
        post '/api/companies',
             params: { company: { name: 'Croatia Airlines' } }.to_json,
             headers: api_headers(token: user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is authorized and params are valid' do
      it 'creates a company' do
        post '/api/companies',
             params: { company: { name: 'Croatia Airlines' } }.to_json,
             headers: api_headers(token: admin.token)

        expect(json_body['company']).to include('name' => 'Croatia Airlines')
      end

      it 'the number of records in the resource table is incremented by one' do
        expect do
          post '/api/companies',
               params: { company: { name: 'Croatia Airlines' } }.to_json,
               headers: api_headers(token: admin.token)
        end.to change(Company, :count).by(1)
      end
    end

    context 'when user is authorized and params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/companies',
             params: { company: { name: '' } }.to_json,
             headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PUT /companies/:id' do
    context 'when params are valid' do
      it 'updates a company' do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: 'Bulgaria Air' } }.to_json,
            headers: api_headers(token: admin.token)
        expect(response).to have_http_status(:ok)
        expect(json_body['company']).to include('name' => 'Bulgaria Air')
      end

      it 'the updates are persisted in database' do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: 'Bulgaria Air' } }.to_json,
            headers: api_headers(token: admin.token)

        expect(Company.first.name).to eq('Bulgaria Air')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: '' } }.to_json,
            headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'DELETE /companies/:id' do
    context 'when the record exists' do
      it 'deletes a company' do
        delete "/api/companies/#{companies.first.id}", headers: api_headers(token: admin.token)

        expect(response).to have_http_status(:no_content)
      end

      it 'the number of records in the resource table is decremented by one' do
        expect do
          delete "/api/companies/#{companies.first.id}", headers: api_headers(token: admin.token)
        end.to change(Company, :count).by(-1)
      end
    end
  end
end
