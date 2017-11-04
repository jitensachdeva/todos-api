require 'rails_helper'

RSpec.describe AuthorizeApiRequest do

  # This is our entry point into the service class
  describe '#call' do

    # Create test user
    let(:user) { create(:user) }

    # returns user object when request is valid
    context 'when valid request' do

      # Mock `Authorization` header
      # let(:header) { { 'Authorization' => token_generator(user.id) } }
      let(:header) { { 'Authorization' => token_generator(user.id) } }

      # Valid request subject
      subject(:request_obj) { described_class.new(header) }

      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    # returns error message when invalid request
    context 'when invalid request' do

      # Invalid request subject
      subject(:invalid_request_obj) { described_class.new({}) }

      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
              .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'when invalid token' do
        let(:header) { { 'Authorization' => token_generator(5) } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
              .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect { request_obj.call }
              .to raise_error(
                      ExceptionHandler::ExpiredSignature,
                      /Signature has expired/
                  )
        end
      end

    end
  end

end