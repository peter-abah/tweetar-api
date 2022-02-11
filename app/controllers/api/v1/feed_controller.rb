module Api
  module V1
    class FeedController < ApplicationController
      include Paginate

      before_action :set_current_user

      def index
        tweets = paginate generate_tweets

        options = {}
        extra_data = { user: @current_user }
        render json: Representer.new(tweets, options, extra_data).as_json, status: :ok
      end

      private

      def generate_tweets
        return FeedGenerator.new(current_user!).feed if user_signed_id?

        Tweet.all
      end

      def set_current_user
        @current_user = user_signed_id? ? current_user! : nil
      end
    end
  end
end