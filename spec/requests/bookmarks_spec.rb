require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:tweet) { FactoryBot.create(:tweet) }
  let(:tweet2) { FactoryBot.create(:tweet) }

  describe "GET /bookmarks" do
    let!(:bookmarks) { FactoryBot.create_list(:bookmark, 50, user: user) }

    it 'returns unauthorized if authentication header is missing' do
      get '/api/v1/bookmarks'
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the correct number of bookmarks (25 based on pagination)' do
      get '/api/v1/bookmarks', headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json['list'].size).to eql(25)
    end

    it 'returns the correct number of tweets if number is specified' do
      get '/api/v1/bookmarks', params: { no: 5 }, 
                            headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json['list'].size).to eql(5)
    end

    it 'returns a sorted response (sorted by date descending)' do
      get '/api/v1/bookmarks', headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      list_json = JSON.parse(response.body)['list']
      first_tweet_date = DateTime.parse(list_json[0]['tweet']['updated_at'])
      second_tweet_date = DateTime.parse(list_json[1]['tweet']['updated_at'])

      expect(response).to have_http_status(:ok)
      expect(first_tweet_date).to be >= second_tweet_date
    end
  end

  describe 'POST /bookmarks' do
    it 'returns unauthorized if authentication header is missing' do
      post "/api/v1/tweets/#{tweet.id}/bookmarks"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      post "/api/v1/tweets/#{tweet.id}/bookmarks", headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unprocessable_entity if user has already bookmarked the tweet' do
      FactoryBot.create(:bookmark, tweet: tweet2, user: user)

      post "/api/v1/tweets/#{tweet2.id}/bookmarks",
           headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'bookmarks a tweet if user is authenticated' do
      post "/api/v1/tweets/#{tweet.id}/bookmarks",
           headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json['tweet']['id']).to eq tweet.id
      expect(json['user']['id']).to eq user.id
    end
  end

  describe 'DELETE /bookmarks/:id' do
    let!(:bookmark) { FactoryBot.create(:bookmark, user: user, tweet: tweet) }

    it 'returns unauthorized if authentication header is missing' do
      delete "/api/v1/tweets/#{tweet.id}/bookmarks"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      delete "/api/v1/tweets/#{tweet.id}/bookmarks", headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns not_found if the bookmark does not belong to user' do
      delete "/api/v1/tweets/#{tweet.id}/bookmarks", headers: { 'Authorization' => AuthenticationTokenService.call(user2.id) }
      expect(response).to have_http_status(:not_found)
    end

    it 'delete bookmark if user is authorized' do
      delete "/api/v1/tweets/#{tweet.id}/bookmarks", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      expect(response).to have_http_status(:no_content)
      expect(Bookmark.exists?(bookmark.id)).to eq(false)
      expect(user.bookmarks).to be_empty
    end
  end
end
