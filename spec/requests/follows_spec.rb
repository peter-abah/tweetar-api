require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe 'POST /follow' do
    let!(:followed_user) { FactoryBot.create(:user) }

    it 'follows a particular user' do
      post '/api/v1/follow', params: { user_id: followed_user.id },
                             headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      updated_user = User.find(user.id)
      updated_followed_user = User.find(followed_user.id)

      expect(response).to have_http_status(:no_content)
      expect(updated_user.followed_users).to include(followed_user)
      expect(updated_followed_user.followers).to include(user)
    end
  end

  describe 'DELETE /follow' do
    let!(:followed_user) { FactoryBot.create(:user) }

    it 'returns not_found if user does not follow the other user' do
      delete '/api/v1/follow', params: { user_id: followed_user.id },
                               headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      expect(response).to have_http_status(:not_found)
    end

    it 'unfollows the user' do
      Follow.create!(follower_id: user.id, followed_id: followed_user.id)

      delete '/api/v1/follow', params: { user_id: followed_user.id },
                               headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      updated_user = User.find(user.id)
      expect(response).to have_http_status(:no_content)
      expect(updated_user.followed_users).not_to include(followed_user)
    end
  end
end
