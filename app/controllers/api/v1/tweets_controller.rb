module Api
  module V1
    class TweetsController < ApplicationController
      before_action :authenticate_request!, only: [:create]

      def index
        tweets = Tweet.all
        render json: tweets, status: :ok
      end

      def create
        tweet = @current_user.tweets.build(tweet_params)

        if tweet.save
          render json: tweet, status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def show
        render json: tweet, status: :ok
      end

      private

      def tweet
        Tweet.find(params[:id])
      end

      def tweet_params
        params.require(:tweet).permit(:body)
      end
    end
  end
end
