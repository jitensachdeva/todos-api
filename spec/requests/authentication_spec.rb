require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do

  # Authentication test suite
  describe 'POST /auth/login' do

    let(:headers){{"Content-Type" => "application/json"}}
    before {post '/auth/login' ,params: credentials, headers: headers }
    # returns auth token when request is valid
    context 'When request is valid' do
      let(:user) {create(:user)}
      let(:credentials)do
        {
            email: user.email,
            password: user.password
        }.to_json
      end

      it 'returns an authetication token' do
        expect(response_body_in_json['auth_token']).not_to be_nil
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      let(:credentials)do
        {
            email: Faker::Internet.email,
            password: Faker::Internet.password
        }.to_json
      end
      it 'returns a failure message' do
        expect(response_body_in_json['message']).to match(/Invalid credentials/)
      end

      it 'returns a status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end
end