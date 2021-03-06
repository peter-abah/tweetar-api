require 'rails_helper'
require_relative './compare_hash'

RSpec.describe 'Users', type: :request do
  describe 'POST /register' do
    it 'authenticates the user' do
      post '/api/v1/register',
           params: { user: { username: 'user1', password: 'password', first_name: 'first', last_name: 'last',
                             email: 'user1@email.com' } }

      json = JSON.parse(response.body)
      expected = {
        'id' => User.last.id,
        'username' => 'user1',
        'authentication_token' => AuthenticationTokenService.call(User.last.id),
        'first_name' => 'first',
        'last_name' => 'last',
        'bio' => '',
        'email' => 'user1@email.com'
      }

      expect(response).to have_http_status(:created)
      expect(compare_hash(expected, json)).to be true
    end
  end

  describe 'GET /users' do
    let!(:users) { FactoryBot.create_list(:user, 50) }

    it 'returns the correct number of users (25 is the default number)' do
      get '/api/v1/users'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['list'].size).to eq(25)
    end

    it 'returns the correct number of users if number is specified' do
      get '/api/v1/users', params: { no: 5 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['list'].size).to eq(5)
    end

    it 'filters users by name if query is provided' do
      # create user to make sure at least a user matches the query
      FactoryBot.create(:user, first_name: 'Anna')

      query = 'an'
      get '/api/v1/users', params: { q: query }

      user = JSON.parse(response.body)['list'][0]

      expect(response).to have_http_status(:ok)
      expect(user['name']).to match query
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { FactoryBot.create(:user, username: 'auser') }

    it 'returns the correct user' do
      get "/api/v1/users/#{user.id}"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['username']).to eq('auser')
    end
  end

  describe "GET /users/:username" do
    let!(:user) { FactoryBot.create(:user, username: 'user') }

    it 'returns the correct user' do
      get "/api/v1/users/user"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(user.id)
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

    it 'updates the user profile image' do
      params = {
        user: {
          profile_image: fixture_file_upload("profile.webp", "image/webp"),
          cover_image: fixture_file_upload("cover.webp", "image/webp")
        }
      }
      patch "/api/v1/users/#{user.id}", params: params,
                                        headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      updated_user = User.find(user.id)
      expect(response).to have_http_status(:ok)

      expect(updated_user.profile_image).to be_attached
      expect(updated_user.cover_image).to be_attached
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { FactoryBot.create(:user, first_name: 'first', last_name: 'last') }
    let!(:user1) { FactoryBot.create(:user) }

    it 'returns unauthorized if authentication header is missing' do
      delete "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns forbidden if token does not correspond to user' do
      delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => AuthenticationTokenService.call(user1.id) }
      expect(response).to have_http_status(:forbidden)
    end

    it 'updates the user if authenticated' do
      delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to eq(false)
    end
  end
end
