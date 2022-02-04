require 'rails_helper'

RSpec.describe 'Feeds', type: :request do
  describe 'GET /feed' do
    let!(:tweets) { FactoryBot.create_list(:tweet, 50) }

    it 'returns the correct number of tweets (25 is the default number)' do
      get '/api/v1/feed'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(25)
    end

    it 'returns the correct number of tweets if number is specified' do
      get '/api/v1/feed', params: { no: 5 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end
end
