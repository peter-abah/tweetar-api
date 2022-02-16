module Api
  module V1
    class TweetsController < ApplicationController
      include Paginate
      include Filterable

      before_action :authenticate_request!, only: %i[create update destroy]

      def index
        filtered_tweets = filter(Tweet.all.includes(images_attachments: :blob))
        tweets = paginate(filtered_tweets)

        render json: json(tweets), status: :ok
      end

      def create
        tweet = @current_user.tweets.build(tweet_params)

        if tweet.save
          render json: json(tweet), status: :created
        else
          render json: { error: user.errors.full_messages.first }, status: :unprocessable_entity
        end
      end

      def show
        render json: json(tweet), status: :ok
      end

      def update
        tweet = @current_user.tweets.find(params[:id])

        if tweet.update(tweet_params)
          render json: json(tweet), status: :ok
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
        render json: json(replies), status: :ok
      end

      private

      def json(data)
        Representer.new(data, options, extra_data).as_json
      end

      def options
        {}
      end

      def extra_data
        { user: @current_user }
      end

      def tweet
        Tweet.includes(images_attachments: :blob).find(params[:id])
      end

      def tweet_params
        params.require(:tweet).permit(:body, :parent_id, images: [],)
      end
    end
  end
end
