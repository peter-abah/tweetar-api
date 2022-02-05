module Api
  module V1
    class FeedController < ApplicationController
      include Paginate

      def index
        tweets = generate_tweets
        tweets = paginate(tweets)
        render json: tweets, status: :ok
      end

      private

      def generate_tweets
        return FeedGenerator.new(current_user!).feed if user_signed_id?

        Tweet.all
      end
    end
  end
end