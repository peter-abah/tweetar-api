require 'rails_helper'
require 'date'

RSpec.describe "Likes", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:tweets) { FactoryBot.create_list(:tweet, 5, user: user) }
  let(:tweet) { tweets.first }
  let!(:likes) do
    tweets.map { |tweet| Like.create!(user_id: user.id, tweet_id: tweet.id) }
  end
  let(:like) { likes.first }

  describe 'GET /likess' do
    context 'when user_id is provided' do
      it 'returns likes for user' do
        get '/api/v1/likes', params: { user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'returns a sorted response (sorted by date descending)' do
        get '/api/v1/likes', params: { user_id: user.id }

        json = JSON.parse(response.body)
        first_like_date = DateTime.parse(json[0]['updated_at'])
        second_like_date = DateTIme.parse(json[1]['updated_at'])

        expect(response).to have_http_status(:ok)
        expect(first_like_date).to be >= second_like_date
      end
    end

    context 'when tweet_id is provided' do
      it 'returns likes for tweet' do
        get '/api/v1/likes', params: { tweet_id: tweet.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it 'returns a sorted response (sorted by date descending)' do
        get '/api/v1/likes', params: { tweet_id: tweet.id }

        json = JSON.parse(response.body)
        first_like_date = DateTime.parse(json[0]['updated_at'])
        second_like_date = DateTIme.parse(json[1]['updated_at'])

        expect(response).to have_http_status(:ok)
        expect(first_like_date).to be >= second_like_date
      end
    end
  end

  describe 'GET /likes/:like_id' do
    it 'returns the specific like' do
      get "/api/v1/likes/#{like.id}"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(like.id)
    end
  end

  describe 'POST /likes' do
    it 'creates a new like' do
      post '/api/v1/likes', params: { like: { user_id: user.id, tweet_id: tweet.id } },
                               headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      updated_tweet = Tweet.find(tweet.id)
      updated_user = User.find(user.id)

      expect(response).to have_http_status(:ok)
      expect(updated_tweet.likes.size).to eq(2)
      expect(updated_user.likes.size).to eq(6)
    end

    it 'returns unauthorized if authorization missing' do
      post '/api/v1/likes', params: { user_id: user.id, tweet_id: tweet.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authorization is invalid' do
      post '/api/v1/likes', params: { user_id: user.id, tweet_id: tweet.id },
                               headers: { 'Authorization': 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE /likes/:like_id' do
    it 'deletes a particular tweet' do
      delete "/api/v1/likes/#{like.id}", headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      updated_user = User.find(user.id)

      expect(response).to have_http_status(:no_content)
      expect(updated_user.likes.size).to eq(4)
    end

    it 'returns unauthorized if authorization missing' do
      delete "/api/v1/likes/#{like.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authorization is invalid' do
      delete "/api/v1/likes/#{like.id}", headers: { 'Authorization': 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
