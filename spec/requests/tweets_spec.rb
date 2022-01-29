require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /tweets" do
    let!(:tweets) { FactoryBot.create_list(:tweet, 5, user: user) }

    it 'returns the correct number of tweets' do
      get '/api/v1/tweets'

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
end
