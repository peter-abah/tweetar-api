require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /register' do
    it 'authenticates the user' do
      post '/api/v1/register',
           params: { user: { username: 'user1', password: 'password', first_name: 'first', last_name: 'last',
                             email: 'user1@email.com' } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
                                                'id' => User.last.id,
                                                'username' => 'user1',
                                                'token' => AuthenticationTokenService.call(User.last.id),
                                                'first_name' => 'first',
                                                'last_name' => 'last',
                                                'bio' => nil,
                                                'email' => 'user1@email.com'
                                              })
    end
  end

  describe 'GET /users' do
    let!(:users) { FactoryBot.create_list(:user, 10) }

    it 'returns the correct number of users' do
      get '/api/v1/users'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user, username: 'auser') }

    it 'returns the correct user' do
      get "/api/v1/users/#{user.id}"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['username']).to eq('auser')
    end
  end

  describe 'PATCH /users/:id' do
    let!(:user) { FactoryBot.create(:user, first_name: 'first', last_name: 'last') }
    let!(:user1) { FactoryBot.create(:user) }

    it 'returns unauthorized if authentication header is missing' do
      patch "/api/v1/users/#{user.id}", params: { user: { first_name: 'update' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      patch "/api/v1/users/#{user.id}", params: { user: { first_name: 'update' } },
                                        headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns forbidden if token does not correspond to user' do
      patch "/api/v1/users/#{user.id}", params: { user: { first_name: 'update' } },
                                        headers: { 'Authorization' => AuthenticationTokenService.call(user1.id) }
      expect(response).to have_http_status(:forbidden)
    end

    it 'updates the user if authenticated' do
      patch "/api/v1/users/#{user.id}", params: { user: { first_name: 'update' } },
                                        headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)
      updated_user = User.find(user.id)

      expect(response).to have_http_status(:ok)
      expect(json['first_name']).to eq('update')
      expect(updated_user.first_name).to eq('update')
    end
  end
end
