module Api
  module V1
    class FeedController < ApplicationController
      include Paginate
      include Orderable

      def index
        tweets = paginate order(generate_tweets)

        options = {}
        extra_data = { user: @current_user }
        render json: Representer.new(tweets, options, extra_data).as_json, status: :ok
      end

      private

      def generate_tweets
        return FeedGenerator.new(current_user!).feed if user_signed_in?

        Tweet.all
      end
    end
  end
end