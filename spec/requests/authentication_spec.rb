require 'rails_helper'
require_relative './compare_hash'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /login' do
    let!(:user) { FactoryBot.create(:user, username: 'user1', email: 'user@email.com', password: 'password') }

    context 'login with username' do
      it 'authenticates the user with username' do
        post '/api/v1/login', params: { username: 'user1', password: 'password' }

        json = JSON.parse(response.body)
        expected = {
          'id' => user.id,
          'username' => 'user1',
          'first_name' => user.first_name,
          'last_name' => user.last_name,
          'bio' => '',
          'email' => 'user@email.com',
          'authentication_token' => AuthenticationTokenService.call(user.id)
        }

        expect(response).to have_http_status(:created)
        expect(compare_hash(expected, json)).to be true
      end

      it 'username is case insentitive' do
        post '/api/v1/login', params: { username: 'UsEr1', password: 'password' }
        expect(response).to have_http_status(:created)
      end
    end
    context 'login with email' do
      it 'authenticates the user with email' do
        post '/api/v1/login', params: { email: 'user@email.com', password: 'password' }

        json = JSON.parse(response.body)
        expected = {
          'id' => user.id,
          'username' => 'user1',
          'first_name' => user.first_name,
          'last_name' => user.last_name,
          'bio' => '',
          'email' => 'user@email.com',
          'authentication_token' => AuthenticationTokenService.call(user.id)
        }

        expect(response).to have_http_status(:created)
        expect(compare_hash(expected, json)).to be true
      end

      it 'email is case insentitive' do
        post '/api/v1/login', params: { email: 'USer@eMAIl.com', password: 'password' }
        expect(response).to have_http_status(:created)
      end
    end

    it 'returns error when username does not exist' do
      post '/api/v1/login', params: { username: 'ac', password: 'password' }
      expect(response).to have_http_status(:unauthorized)
    end
    it 'returns error when password is incorrect' do
      post '/api/v1/login', params: { username: user.username, password: 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
