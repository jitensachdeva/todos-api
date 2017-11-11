require 'rails_helper'

describe 'POST /signup' do

  let(:headers) {request_headers}
  let(:user) {build(:user)}
  context 'when valid request' do


    let(:valid_attributes)do
      attributes_for(:user,  password_confirmation: user.password)
    end
    before {post '/signup', params:valid_attributes.to_json, headers: headers}

    it 'returns success code' do
      expect(response).to have_http_status(:created)
    end

    it 'return success method' do
      expect(response_in_json["message"]).to match(/Account created/)
    end

    it 'returns an authentication token' do
      expect(response_in_json['auth_token']).not_to be_nil
    end

  end

  context 'when invalid request' do
    let(:invalid_attributes)do
      attributes_for(:user,  password_confirmation: 'abc')
    end

    before {post '/signup', params:invalid_attributes.to_json, headers: headers}

    it 'returns error code -422' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns failure message' do
      expect(response_in_json['message']).to match(/Validation failed: Password confirmation doesn't match Password/)
    end
  end

end