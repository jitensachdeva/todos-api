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
      expect(response_body_in_json).not_to be_empty
      expect(response_body_in_json.size).to eq(10)
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
        expect(response_body_in_json).not_to be_empty
        expect(response_body_in_json['id']).to eq(todo_id)
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

# Test suite for POST /todos
  describe 'POST /todos' do
    context 'when the request is valid' do
      # valid payload
      let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

      before { post '/todos', params: valid_attributes }
      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a todo' do
        expect(response_body_in_json['title']).to eq('Learn Elm')
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Created by can't be blank/)
      end

    end

  end

# Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }
    before { put "/todos/#{todo_id}", params: valid_attributes }

    context 'when the record exists' do
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the record do not exists' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end


  end

# Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end

    context 'when the record do not exists' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

  end

end