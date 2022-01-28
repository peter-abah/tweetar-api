require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /register' do
    it 'authenticates the user' do
      post '/api/v1/register',
           params: { user: { username: 'user1', password: 'password', first_name: 'first', last_name: 'last' } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
                                                'id' => User.last.id,
                                                'username' => 'user1',
                                                'token' => AuthenticationTokenService.call(User.last.id),
                                                'first_name' => 'first',
                                                'last_name' => 'last',
                                                'bio' => nil
                                              })
    end
  end
end
