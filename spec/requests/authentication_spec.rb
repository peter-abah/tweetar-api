require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /login' do
    let(:user) { FactoryBot.create(:user, username: 'user1', password: 'password') }

    it 'authenticates the user' do
      post '/api/v1/login', params: { username: user.username, password: 'password' }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
                                                'id' => user.id,
                                                'username' => 'user1',
                                                'first_name' => user.first_name,
                                                'last_name' => user.last_name,
                                                'bio' => nil,
                                                'email' => user.email,
                                                'token' => AuthenticationTokenService.call(user.id)
                                              })
    end
    it 'returns error when username does not exist' do
      post '/api/v1/login', params: { username: 'ac', password: 'password' }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({
                                                'error' => 'No such user'
                                              })
    end
    it 'returns error when password is incorrect' do
      post '/api/v1/login', params: { username: user.username, password: 'incorrect', bio: nil }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({
                                                'error' => 'Incorrect password'
                                              })
    end
  end
end
