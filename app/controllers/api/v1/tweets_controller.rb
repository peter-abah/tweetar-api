module Api
  module V1
    class TweetsController < ApplicationController
      include Paginate

      before_action :authenticate_request!, only: %i[create update destroy]

      def index
        tweets = paginate(Tweet.all.includes(images_attachments: :blob))
        tweets_json = TweetsRepresenter.new(tweets, @current_user).as_json
        render json: tweets_json, status: :ok
      end

      def create
        tweet = @current_user.tweets.build(tweet_params)
        tweet_json = TweetRepresenter.new(tweet, @current_user).as_json

        if tweet.save
          render json: tweet_json, status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def show
        tweet_json = TweetRepresenter.new(tweet, @current_user).as_json
        render json: tweet_json, status: :ok
      end

      def update
        tweet = @current_user.tweets.find(params[:id])

        if tweet.update(tweet_params)
          tweet_json = TweetRepresenter.new(tweet, @current_user).as_json
          render json: tweet_json, status: :ok
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def destroy
        tweet = @current_user.tweets.find(params[:id])
        tweet.destroy
        render status: :no_content
      end

      def replies
        replies = paginate(tweet.replies)
        replies_json = TweetsRepresenter.new(replies, @current_user).as_json
        render json: replies_json, status: :ok
      end

      private

      def tweet
        Tweet.find(params[:id]).includes(images_attachments: :blob)
      end

      def tweet_params
        params.require(:tweet).permit(:body, images: [])
      end
    end
  end
end
