require 'rails_helper'

RSpec.describe 'Todos API', type: :request do

  let!(:todos) {create_list(:todo, 10)}
  let(:todo_id) {todos.first.id}

# Test suite for GET /todos
  describe 'GET /todos' do
    before { get '/todos' }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns todos' do
      expect(response_in_json).not_to be_empty
      expect(response_in_json.size).to eq(10)
    end

  end

# Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before {get "/todos/#{todo_id}"}

    context 'when the record exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the todo' do
        expect(response_in_json).not_to be_empty
        expect(response_in_json['id']).to eq(todo_id)
      end
    end

    context 'when the record do not exists' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end

  end

end