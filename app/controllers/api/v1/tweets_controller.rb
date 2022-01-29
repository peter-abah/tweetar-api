module Api
  module V1
    class TweetsController < ApplicationController
      def index
        tweets = Tweet.all
        render json: tweets, status: :ok
      end

      def show
        render json: tweet, status: :ok
      end

      private

      def tweet
        Tweet.find(params[:id])
      end
    end
  end
end
