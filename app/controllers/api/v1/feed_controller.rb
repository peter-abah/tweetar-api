module Api
  module V1
    class FeedController < ApplicationController
      include Paginate

      def index
        tweets = paginate generate_tweets
        render json: TweetsRepresenter.new(tweets).as_json, status: :ok
      end

      private

      def generate_tweets
        return FeedGenerator.new(current_user!).feed if user_signed_id?

        Tweet.all
      end
    end
  end
end