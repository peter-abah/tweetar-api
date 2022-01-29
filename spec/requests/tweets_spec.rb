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
end
