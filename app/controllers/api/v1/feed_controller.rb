module Api
  module V1
    class FeedController < ApplicationController
      include Paginate
      include Orderable

      def index
        @feed = paginate order(generate_tweets)
      end

      private

      def generate_tweets
        return FeedGenerator.new(current_user!).feed if user_signed_in?

        Tweet.all
      end
    end
  end
end