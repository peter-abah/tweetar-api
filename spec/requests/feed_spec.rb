require 'rails_helper'
require 'date'

RSpec.describe 'Feeds', type: :request do
  describe 'GET /feed' do
    let!(:tweets) { FactoryBot.create_list(:tweet, 50) }
    let!(:user) { FactoryBot.create(:user) }

    it 'returns the correct number of tweets (25 is the default number)' do
      get '/api/v1/feed'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['list'].size).to eq(25)
    end

    it 'returns the tweets if user is authenticated' do
      get '/api/v1/feed', headers: { 'Authorization': AuthenticationTokenService.call(user.id) }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['list'].size).to eq(25)
    end

    it 'returns the correct number of tweets if number is specified' do
      get '/api/v1/feed', params: { no: 5 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['list'].size).to eq(5)
    end

    it 'returns a sorted response (sorted by date descending)' do
      get '/api/v1/feed'

      list_json = JSON.parse(response.body)['list']
      first_tweet_date = DateTime.parse(list_json[0]['tweet']['updated_at'])
      second_tweet_date = DateTime.parse(list_json[1]['tweet']['updated_at'])

      expect(response).to have_http_status(:ok)
      expect(first_tweet_date).to be >= second_tweet_date
    end
  end
end
