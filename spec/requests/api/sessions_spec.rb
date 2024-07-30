require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST #create' do
    let(:user) { create(:user, password: 'password123', token: 'token123') }

    context 'with valid credentials' do
      it 'returns a token' do
        post '/api/session', params: {
          session: { email: user.email, password: 'password123' }
        }.to_json,
                             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['session']).to have_key('token')
        expect(json_body['session']['token']).to eq(user.reload.token)
        expect(json_body['session']).to have_key('user')
        expect(json_body['session']['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns bad_request status' do
        post '/api/session', params: {
          session: { email: user.email, password: 'invalid' }
        }.to_json,
                             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to have_key('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, password: 'password123') }

    before do
      user.login
    end

    context 'with valid token' do
      it 'logs out the user' do
        delete '/api/session', headers: api_headers(token: user.token)
        expect(response).to have_http_status(:no_content)
        expect(user.reload.token).not_to be_nil
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized status' do
        delete '/api/session', headers: api_headers(token: 'invalid')
        expect(response).to have_http_status(:unauthorized)
        expect(json_body).to have_key('errors')
      end
    end
  end
end
