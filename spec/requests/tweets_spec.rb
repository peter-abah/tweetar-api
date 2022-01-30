require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /tweets" do
    let!(:tweets) { FactoryBot.create_list(:tweet, 50, user: user) }

    it 'returns the correct number of tweets (25 based on pagination)' do
      get '/api/v1/tweets'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json.size).to eql(25)
    end

    it 'returns the correct number of tweets if number is specified' do
      get '/api/v1/tweets', params: { no: 5 }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json.size).to eql(5)
    end
  end

  describe "GET /tweets/:id" do
    let!(:tweet) { FactoryBot.create(:tweet, user: user) }

    it 'returns the correct tweet' do
      get "/api/v1/tweets/#{tweet.id}"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be(tweet.as_json)
    end
  end

  describe "POST /tweets" do
    it 'returns unauthorized if authentication header is missing' do
      post '/api/v1/tweets/', params: { tweet: { body: 'A tweet' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      post '/api/v1/tweets/', params: { tweet: { body: 'A tweet' } }, 
                           headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates the tweet if the user is authenticated' do
      post '/api/v1/tweets/', params: { tweet: { body: 'A tweet' } }, 
                           headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)
      new_tweet = Tweet.find(json['id'])

      expect(response).to have_http_status(:created)
      expect(json['body']).to eql('A tweet')
      expect(new_tweet.body).to eql('A tweet') # checks tweet is created
      expect(new_tweet.user).to eql(user)
    end
  end

  describe 'PATCH /tweets/:id' do
    let!(:user2) { FactoryBot.create(:user) }
    let!(:tweet) { FactoryBot.create(:tweet, user: user) }

    it 'returns unauthorized if authentication header is missing' do
      patch "/api/v1/tweets/#{tweet.id}", params: { tweet: { body: 'update' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      patch "/api/v1/tweets/#{tweet.id}", params: { tweet: { body: 'update' } }, 
                                          headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns not_found if the user tweet is not found' do
      patch "/api/v1/tweets/#{tweet.id}", params: { tweet: { body: 'update' } }, 
                                          headers: { 'Authorization' => AuthenticationTokenService.call(user2.id) }
      expect(response).to have_http_status(:not_found)
    end

    it 'updates tweet if user is authorized' do
      patch "/api/v1/tweets/#{tweet.id}", params: { tweet: { body: 'update' } }, 
                                          headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)
      updated_tweet = Tweet.find(tweet.id)

      expect(response).to have_http_status(:ok)
      expect(json['body']).to eq('update')
      expect(updated_tweet.body).to eq('update')
    end
  end

  describe 'DELETE /tweets/:id' do
    let!(:user2) { FactoryBot.create(:user) }
    let!(:tweet) { FactoryBot.create(:tweet, user: user) }

    it 'returns unauthorized if authentication header is missing' do
      delete "/api/v1/tweets/#{tweet.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized if authentication token is invalid' do
      delete "/api/v1/tweets/#{tweet.id}", headers: { 'Authorization' => 'awrongtoken123456' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns not_found if the user tweet is not found' do
      delete "/api/v1/tweets/#{tweet.id}", headers: { 'Authorization' => AuthenticationTokenService.call(user2.id) }
      expect(response).to have_http_status(:not_found)
    end

    it 'delete tweet if user is authorized' do
      delete "/api/v1/tweets/#{tweet.id}", headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      expect(response).to have_http_status(:no_content)
      expect(Tweet.exists?(tweet.id)).to eq(false)
    end
  end

  describe 'GET /tweets/:id/replies' do
    let!(:tweet) { FactoryBot.create(:tweet, user: user) }
    let!(:replies) { FactoryBot.create_list(:tweet, 10, user: user, parent_id: tweet.id) }

    it 'returns replies of a tweet' do
      get "/api/v1/tweets/#{tweet.id}/replies"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end
end
