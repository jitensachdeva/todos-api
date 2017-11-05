require 'rails_helper'

RSpec.describe AuthenticateUser do

  # Test suite for AuthenticateUser#call
  describe '#call' do

    # return token when valid request
    context 'when valid credentials' do
      let(:user) {create(:user)}
      let(:valid_auth_obj){described_class.new(user.email, user.password)}
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    # raise Authentication Error when invalid request
    context 'when invalid credentials' do
      let(:valid_auth_obj){described_class.new('foo@bar.com', 'foobar')}
      it 'raises an authentication error' do
        expect { valid_auth_obj.call }
            .to raise_error(
                    ExceptionHandler::AuthenticationError,
                    /Invalid credentials/
                )
      end
    end
  end
end