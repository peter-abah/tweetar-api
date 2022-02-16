require 'rails_helper'
require 'date'

RSpec.describe "Tweets", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /tweets" do
    let!(:tweets) { FactoryBot.create_list(:tweet, 50, user: user) }

    it 'returns the correct number of tweets (25 based on pagination)' do
      get '/api/v1/tweets'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json['list'].size).to eql(25)
    end

    it 'returns the correct number of tweets if number is specified' do
      get '/api/v1/tweets', params: { no: 5 }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json).not_to be_empty
      expect(json['list'].size).to eql(5)
    end

    it 'returns a sorted response (sorted by date descending)' do
      get '/api/v1/tweets'

      list_json = JSON.parse(response.body)['list']
      first_tweet_date = DateTime.parse(list_json[0]['tweet']['updated_at'])
      second_tweet_date = DateTime.parse(list_json[1]['tweet']['updated_at'])

      expect(response).to have_http_status(:ok)
      expect(first_tweet_date).to be >= second_tweet_date
    end

    it 'filters users by name if query is provided' do
      # create tweet to make sure at least a tweet matches the query
      FactoryBot.create(:tweet, body: 'Grep test')

      query = 'ep'
      get '/api/v1/tweets', params: { q: query }

      tweet = JSON.parse(response.body)['list'][0]

      expect(response).to have_http_status(:ok)
      expect(tweet['tweet']['body']).to match query
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
      expect(json['tweet']['body']).to eql('A tweet')
      expect(new_tweet.body).to eql('A tweet') # checks tweet is created
      expect(new_tweet.user).to eql(user)
    end

    it 'creates a tweets with images' do
      images = [
        fixture_file_upload("1.jpg", "image/jpeg"),
        fixture_file_upload("2.jpg", "image/jpeg")
      ]

      post '/api/v1/tweets/', params: { tweet: { body: 'A tweet', images: images } },
                           headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

      json = JSON.parse(response.body)
      new_tweet = Tweet.find(json['id'])

      expect(response).to have_http_status(:created)
      expect(new_tweet.images).to be_attached
      expect(new_tweet.images.size).to be 2
    end

    context 'replying a tweet' do
      let!(:tweet) { FactoryBot.create(:tweet) }

      it 'creates a tweet replying to specified tweet' do
        post '/api/v1/tweets/', params: { tweet: { body: 'A tweet', parent_id: tweet.id } }, 
                                headers: { 'Authorization' => AuthenticationTokenService.call(user.id) }

        json = JSON.parse(response.body)
        parent_id = json['tweet']['parent']['id']
        reply_id = json['id']
        new_tweet = tweet.replies.find(reply_id)

        expect(response).to have_http_status(:created)
        expect(parent_id).to eq(tweet.id)
        expect(reply_id).to eq(new_tweet.id)
      end
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
      expect(json['tweet']['body']).to eq('update')
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
      expect(JSON.parse(response.body)['list'].size).to eq(10)
    end
  end
end
