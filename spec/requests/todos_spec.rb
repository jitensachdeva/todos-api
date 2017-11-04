require 'rails_helper'

RSpec.describe 'Todos API', type: :request do

  let!(:todos) {create_list(:todo, 10)}

  describe 'GET /todos' do
    before { get '/todos' }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
    
  end


end