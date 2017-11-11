require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#authorize_request" do

    before {allow(request).to receive(:headers).and_return(headers)}

    context "when auth token is passed" do
      let(:user) {create(:user)}
      let(:headers) { { 'Authorization' => token_generator(user.id) } }

      # private method authorize_request returns current user
      it "sets the current user" do
        expect(subject.instance_eval { authorize_request } ).to eq(user)
      end
    end

    context "when auth token is not passed" do
      let(:headers) { { 'Authorization' => nil } }
      # before{allow(request).to receive(:headers).and_return(headers)}

      it "raises MissingToken error" do
        expect { subject.instance_eval { authorize_request } }.
            to raise_error(ExceptionHandler::MissingToken, /Missing token/)
      end
    end

  end
end
